import requests
import urllib
import requests, re
import sys
from bs4 import BeautifulSoup
if len(sys.argv) == 1:
    exit(1)
base_url = "https://uupdump.ml/"
X64_DONE = False
USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:65.0) Gecko/20100101 Firefox/65.0"
headers = {"user-agent" : USER_AGENT}
resp = requests.get(base_url+"known.php", headers=headers)
if resp.status_code == 200:
    soup = BeautifulSoup(resp.content, "html.parser")
    data = []
    table = soup.find('table', attrs={'class':'ui celled striped table'})
    rows = table.find_all('tr')
    for row in rows:
        cols = row.find_all('td')
        column=[]
        for ele in cols:
            if ele.find_all('a', attrs={'href': re.compile("^./")}):
                link = ele.find('a', attrs={'href': re.compile("^./")})
                column.append(link.get("href").split("./selectlang.php?id=")[1])
            else:
                column.append(ele.text.strip())
        cols = column
        data.append([ele for ele in cols if ele])
    for i in data:
        if sys.argv[1] in i:
            with open("Extracted_Files.txt", "r+") as elist:
                extracted = elist.readlines()
                if i[0]+"\n" in extracted:
                    print("The latest update for "+sys.argv[1]+" has already been pushed to OSDN!")
                    exit(1)
                URL = base_url+"get.php?"
                URL += "id="+i[0]
                URL += "&pack=en-us"
                URL += "&edition=core;coren;professional;professionaln"
                data = {"autodl":	"3",
                        "updates":	"1",
                        "virtualEditions[]": ["CoreSingleLanguage","ProfessionalWorkstation","ProfessionalEducation","Education","Enterprise","ServerRdsh","IoTEnterprise","ProfessionalWorkstationN","ProfessionalEducationN","EducationN","EnterpriseN"]
                        }
                resp = requests.post(URL, headers=headers, data=data)
                open("windows.zip", "wb").write(resp.content)
                elist.write(i[0]+"\n")
                break
