## description
물리 개발 장비 로컬에서 jupyer notebook, spark client server를 띄워 작업하기 위해 필요한 인프라입니다.

## Getting started
도커 기반으로 인프라를 세팅합니다.
### Prerequisites
- aws 접근 환경변수 설정
```bash
mv ./conf_template ./conf
```
`infra/conf/spark-defaults.conf` 파일, `.env` 파일에 aws access id, secret 명시

- 파이썬 리이브러리 명시
`infra/requirments.txt` 에 필요한 파이썬 라이브러리 명시

### Installation
최초 실행, 이후 컨테이너 구동
`docker-compose up -d`

spark config 파일이나 파이썬 라이브러리 도커 이미지에 추가하여 재빌드하려는 경우
`docker-compose up --build -d`
