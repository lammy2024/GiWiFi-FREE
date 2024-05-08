import random
import requests
from datetime import datetime

headers = {
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
    "Accept-Encoding": "gzip, deflate",
    "Accept-Language": "zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6",
    "Cache-Control": "no-cache",
    "Connection": "keep-alive",
    "Cookie": "PHPSESSID=7rgrwf7ktgd35buhyetg5rno1; wechatpay=0",
    "Host": "as.gwifi.com.cn",
    "Pragma": "no-cache",
    "Upgrade-Insecure-Requests": "1",
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36 Edg/124.0.0.0"
}

random_number = str(random.randint(10000000, 99999999))  # Generate a random 8-digit number initially

url = f"http://as.gwifi.com.cn/gportal/web/sendPassby?wlanuserip=&wlanacname=&_={str(random.randint(10000, 99999))}{random_number}"

# Send the GET request
response = requests.get(url, headers=headers)

# Check if the request was successful (status code 200)
if response.status_code == 200:
    print("请求成功，当前时间：" + datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
    print("响应内容：", response.text)
else:
    print("请求失败，状态码：", response.status_code)


