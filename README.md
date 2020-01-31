# 2020_01_30_terraform

source : https://www.44bits.io/ko/post/terraform_introduction_infrastrucute_as_code

[Tutorial]
- 첫 번째 이터레이션: EC2 용 SSH 키 페어 정의 -> 첫 번째 스텝: HCL 언어로 필요한 리소스를 정의 (Depreciated expressions)
- 세 번째 이터레이션: EC2 인스턴스 정의 -> Default VPC  
    (name이 default인 Security Group이 2개가 존재하여, vpc_id로 구분해줌)
- 네 번째 이터레이션: RDS 인스턴스 정의 -> Engine version(5.7.22), Password 설정 필요  

[Example 1]
- Create VPC, 4 subnets(2 public/ 2 private), 1 internet gateway, 1 NAT gateway, 2 instance (1 public / 1 private), 1 ALB, 2 Security group
- Nginx install

*** Be care
- Security group -> egress (egress is not default value)
- ALB target group -> name (only alphanumeric characters and hyphens allowed in "name")  

[Example 2]
- Simple version of Exapmle 1 for test
- Create VPC, 1 Subnets, 1 Internet gateway, 1 Instance, 1 Security group

# 2020_01_31_Ansible

source1 : https://jojoldu.tistory.com/432  
source2 : https://jojoldu.tistory.com/433  
source3 : https://jojoldu.tistory.com/438  

[Tutorial]

*** 시작하기 전
- VPC, Subnet(public), Security Group, Instance, Internet gateway 각각 1개씩 있다고 가정(Server)
- Terraform으로 실습 환경 생성하기 (기존의 Subnet 1개, Security group(ICMP, SSH, HTTP, HTTPS) 1개를 적용한 2대의 Instance(Host) 생성)

*** 주요 내용
- Server Instance에서 2대의 Host Instance에 SSH 접속할 수 있도록 authroized keys 추가 (생성 후 추가하였음)
- 1대의 Server에서 Ansible을 설치 후 2대의 Host Instance에 새로운 유저 추가
- 비밀번호 변경 및 추가한 유저에 권한 부여(site.yml)


source : https://blog.naver.com/alice_k106/221333208746

[Install nginx]
- Tutorial에서 생성한 2대의 Host Instance에 Nginx 설치(nginx.yml)

[Example 1]
- 디버그 모듈을 활용(debug.yml)

source : https://november11tech.tistory.com/112?category=297380

[Example 2]
- 변수 받기(var.yml)