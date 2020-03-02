from django.http import HttpResponse
from django.shortcuts import render

import subprocess
import shlex


def homepage(r):
    return render(r, 'homepage/index.html')


def download(r):
    if "jkhdhmlKLJHFLD90073%M**$ùl:KO?OFio,oi" == r.POST["password"]:
        file_name = "video.mp4"
        cmd = 'rm ' + file_name
        print(cmd)
        subprocess.call(shlex.split(cmd))
        cmd = './download_youtube.sh ' + r.POST["url"] + ' ' + r.POST["start"] + ' ' + r.POST["end"] + ' ' + file_name
        print(cmd)
        subprocess.call(shlex.split(cmd))

        file = open(file_name, 'rb')
        response = HttpResponse(file, content_type="video/mpeg")
        response['Content-Disposition'] = "attachment; filename=%s" % file_name
        return response
    else:
        return homepage(r)
