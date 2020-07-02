#
# Copyright © 2020 Maestro Creativescape
#
# SPDX-License-Identifier: GPL-3.0
#
# Python script to fetch the latest windows ISO of given architecture.
# Pass architecture as command line argument

import requests
import urllib
import requests, re
import sys
from bs4 import BeautifulSoup

base_url = "https://uupdump.ml/"
USER_AGENT = (
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:65.0) Gecko/20100101 Firefox/65.0"
)
headers = {"user-agent": USER_AGENT}

if len(sys.argv) == 1:
    exit(1)

if len(sys.argv) == 3:
    edition = sys.argv[1]
    build_id = sys.argv[2]
    URL = base_url + "get.php?"
    URL += "id=" + build_id
    URL += "&pack=en-us"
    if edition == "arm64":
        URL += "&edition=core;professional"
        data = {
            "autodl": "3",
            "updates": "1",
            "virtualEditions[]": [
            "CoreSingleLanguage",
            "ProfessionalWorkstation",
            "ProfessionalEducation",
            "Education",
            "Enterprise",
            "ServerRdsh",
            "IoTEnterprise",
            ],
        }
    else:
        URL += "&edition=core;coren;professional;professionaln"
        data = {
            "autodl": "3",
            "updates": "1",
            "virtualEditions[]": [
            "CoreSingleLanguage",
            "ProfessionalWorkstation",
            "ProfessionalEducation",
            "Education",
            "Enterprise",
            "ServerRdsh",
            "IoTEnterprise",
            "ProfessionalWorkstationN",
            "ProfessionalEducationN",
            "EducationN",
            "EnterpriseN",
            ],
        }
    resp = requests.post(URL, headers=headers, data=data)
    open("windows.zip", "wb").write(resp.content)
    exit(0)

resp = requests.get(base_url + "known.php", headers=headers)
if resp.status_code == 200:
    soup = BeautifulSoup(resp.content, "html.parser")
    data = []
    table = soup.find("table", attrs={"class": "ui celled striped table"})
    rows = table.find_all("tr")
    for row in rows:
        cols = row.find_all("td")
        cols = [ele.text.strip() for ele in cols]
        data.append([ele for ele in cols if ele])
    for i in data:
        if sys.argv[1] in i:
            with open("Extracted_Files.txt", "r+") as elist:
                extracted = elist.readlines()
                if i[2] + "\n" in extracted:
                    print(
                        "The latest update for "
                        + sys.argv[1]
                        + " has already been pushed to OSDN!"
                    )
                    exit(1)
                URL = base_url + "get.php?"
                URL += "id=" + i[2]
                URL += "&pack=en-us"
                if sys.argv[1] == "arm64":
                    URL += "&edition=core;professional"
                    data = {
                        "autodl": "3",
                        "updates": "1",
                        "virtualEditions[]": [
                            "CoreSingleLanguage",
                            "ProfessionalWorkstation",
                            "ProfessionalEducation",
                            "Education",
                            "Enterprise",
                            "ServerRdsh",
                            "IoTEnterprise",
                        ],
                    }
                else:
                    URL += "&edition=core;coren;professional;professionaln"
                    data = {
                        "autodl": "3",
                        "updates": "1",
                        "virtualEditions[]": [
                            "CoreSingleLanguage",
                            "ProfessionalWorkstation",
                            "ProfessionalEducation",
                            "Education",
                            "Enterprise",
                            "ServerRdsh",
                            "IoTEnterprise",
                            "ProfessionalWorkstationN",
                            "ProfessionalEducationN",
                            "EducationN",
                            "EnterpriseN",
                        ],
                    }
                resp = requests.post(URL, headers=headers, data=data)
                open("windows.zip", "wb").write(resp.content)
                elist.write(i[2] + "\n")
                break