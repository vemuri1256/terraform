#
# MAINTAINER Vitaliy Natarov "vitaliy.natarov@yahoo.com"
#
terraform {
  required_version = "> 0.9.0"
}
provider "aws" {
    region  = "us-east-1"
    profile = "default"
    # Make it faster by skipping something
    #skip_get_ec2_platforms      = true
    #skip_metadata_api_check     = true
    #skip_region_validation      = true
    #skip_credentials_validation = true
    #skip_requesting_account_id  = true
}
module "iam" {
    source                          = "../../modules/iam"
    name                            = "TEST-AIM"
    region                          = "us-east-1"
    environment                     = "PROD"

    aws_iam_role-principals         = [
        "ec2.amazonaws.com",
    ]
    aws_iam_policy-actions           = [
        "cloudwatch:GetMetricStatistics",
        "logs:DescribeLogStreams",
        "logs:GetLogEvents",
        "elasticache:Describe*",
        "rds:Describe*",
        "rds:ListTagsForResource",
        "ec2:DescribeAccountAttributes",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs",
        "ec2:Owner",
    ]
}
module "vpc" {
    source                              = "../../modules/vpc"
    name                                = "TEST-VPC"
    environment                         = "PROD"
    # VPC
    instance_tenancy                    = "default"
    enable_dns_support                  = "true"
    enable_dns_hostnames                = "true"
    assign_generated_ipv6_cidr_block    = "false"
    enable_classiclink                  = "false"

    vpc_cidr                            = "172.31.0.0/16"
    private_subnet_cidrs                = ["172.31.64.0/20"]
    public_subnet_cidrs                 = ["172.31.80.0/20"]
    availability_zones                  = ["us-east-1a"]
    allowed_ports                       = ["8080", "3306", "80", "443"]

    #Internet-GateWay
    enable_internet_gateway             = "true"
    #NAT
    enable_nat_gateway                  = "false"
    single_nat_gateway                  = "true"
    #VPN
    enable_vpn_gateway                  = "false"
    #DHCP
    enable_dhcp_options                 = "false"
    # EIP
    enable_eip                          = "false"
}
#module "kms" {
#    source               = "../../modules/kms"
#    name                 = "TEST-KMS"
#    environment          = "PROD"
#
#    aws_account_id       = "XXXXXXXXXXXXXXXXX"
#}
#module "s3" {
#    source                              = "../../modules/s3"
#    name                                = "My-backet"
#    environment                         = "PROD"
#
#    #
#    s3_acl          = "log-delivery-write"  #"private"
#    force_destroy   = "true"
#    # Allow public web-site (Static website hosting)
#    website         = [
#    {
#        index_document = "index.html"
#        error_document = "error.html"
#        #redirect_all_requests_to = "https://s3-website.linux-notes.org"
#    },
#    ]
#    # Use cors rules
#    cors_rule       = [
#    {
#        allowed_headers = ["*"]
#        allowed_methods = ["PUT", "POST"]
#        allowed_origins = ["https://s3-website.linux-notes.org"]
#        expose_headers  = ["ETag"]
#        max_age_seconds = 3000
#    },
#    ]
#
#    kms_master_key_id = "arn:aws:kms:${module.kms.region}:${module.kms.aws_account_id}:key/${module.kms.kms_key_id}"
#}
module "elb" {
    source                              = "../../modules/elb"
    name                                = "TEST-ELB"
    region                              = "us-east-1"
    environment                         = "PROD"

    security_groups                     = ["${module.vpc.security_group_id}"]
    
    # Need to choose subnets or availability_zones. The subnets has been chosen.
    subnets                             = ["${element(module.vpc.vpc-publicsubnet-ids, 0)}"]
    
    #access_logs = [
    #    {
    #        bucket = "${module.s3.bucket_name}"
    #        bucket_prefix = "bar"
    #        interval = 60
    #    },
    #]
    listener = [
        {
            instance_port     = "80"
            instance_protocol = "HTTP"
            lb_port           = "80"
            lb_protocol       = "HTTP"
        },
    #    {
    #        instance_port      = 443
    #        instance_protocol  = "https"
    #        lb_port            = 443
    #        lb_protocol        = "https"
    #        ssl_certificate_id = "${var.elb_certificate}"
    #    },
    ]
    health_check = [
        {
            target              = "HTTP:80/"
            interval            = 30
            healthy_threshold   = 2
            unhealthy_threshold = 2
            timeout             = 5
        }
    ]
    # You could use ONE health_check!
    #health_check = [
    #    {
    #        target              = "HTTP:443/"
    #        interval            = 30
    #        healthy_threshold   = 2
    #        unhealthy_threshold = 2
    #        timeout             = 5
    #    }
    #]
    # Enable 
    enable_lb_cookie_stickiness_policy_http  = true
    # Enable 
    enable_app_cookie_stickiness_policy_http = "true"
}
module "asg" {
    source                              = "../../modules/asg"
    name                                = "TEST-ASG"
    region                              = "us-east-1"
    environment                         = "PROD"

    security_groups = ["${module.vpc.security_group_id}"]
    
    root_block_device  = [
        {
            volume_size = "8"
            volume_type = "gp2"
        },
    ]
    placement_tenancy        = "${module.vpc.instance_tenancy}"    

    # Auto scaling group
    #asg_name                  = "example-asg"
    vpc_zone_identifier       = ["${module.vpc.vpc-publicsubnet-ids}"]
    health_check_type         = "EC2"
    asg_min_size              = 0
    asg_max_size              = 1
    desired_capacity          = 1
    wait_for_capacity_timeout = 0

    load_balancers            = ["${module.elb.elb_name}"]
    monitoring                = "true"
    #
    enable_autoscaling_schedule = true
}
module "cpualarm-up" {
    source              = "../../modules/cloudwatch"

    alarm_name          = "monitor EC2 instance cpu utilization"
    alarm_description   = "This metric monitor EC2 instance cpu utilization"
    alarm_actions       = ["${module.asg.this_autoscaling_group_arn}"]
    
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = "2"
    metric_name         = "CPUUtilization" 
    namespace           = "AWS/EC2"
    period              = "120" 
    statistic           = "Average" 
    threshold           = "60" 


    dimensions = [
        {
          AutoScalingGroupName = "${module.asg.autoscaling_policy_scale_up_arn}"
        }
    ]

}
module "cpualarm-down" {
    source              = "../../modules/cloudwatch"

    alarm_name          = "monitor EC2 instance cpu utilization - down"
    alarm_description   = "This metric monitor EC2 instance cpu utilization"
    alarm_actions       = ["${module.asg.this_autoscaling_group_arn}"]

    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods  = "2"
    metric_name         = "CPUUtilization"
    namespace           = "AWS/EC2"
    period              = "120"
    statistic           = "Average"
    threshold           = "10"


    dimensions = [
        {
          AutoScalingGroupName = "${module.asg.autoscaling_policy_scale_down_arn}"
        }
    ]

}

