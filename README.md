# 2020_01_30_terraform

source : https://www.44bits.io/ko/post/terraform_introduction_infrastrucute_as_code

[Tutorial]
- 첫 번째 이터레이션: EC2 용 SSH 키 페어 정의 -> 첫 번째 스텝: HCL 언어로 필요한 리소스를 정의 (Depreciated expressions)
- 세 번째 이터레이션: EC2 인스턴스 정의 -> Default VPC (name이 default인 Security Group이 2개가 존재하여, vpc_id로 구분해줌)
- 네 번째 이터레이션: RDS 인스턴스 정의 -> Engine version(5.7.22), Password 설정 필요

[Example 1]
- Create VPC, 4 subnets(2 public/ 2 private), 1 internet gateway, 1 NAT gateway, 2 instance (1 public / 1 private), 1 ALB, 2 Security group
- Nginx install

Be care
- Security group -> egress (egress is not default value)
- ALB target group -> name (only alphanumeric characters and hyphens allowed in "name")

[Example 2]
- Simple version of Exapmle 1 for test
- Create VPC, 1 Subnets, 1 Internet gateway, 1 Instance, 1 Security group