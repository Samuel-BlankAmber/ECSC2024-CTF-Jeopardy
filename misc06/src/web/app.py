import os
import subprocess

from flask import Flask, request, Response
from werkzeug.utils import secure_filename

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = '/tmp'
app.config['MAX_CONTENT_LENGTH'] = 32 * 1024 * 1024  # 32MiB

EMULATOR_HOST = os.getenv('EMULATOR_HOST', 'emulator')


def connect_adb():
    subprocess.check_call(['adb', 'connect', f'{EMULATOR_HOST}:5555'])


def install_app(filename: str):
    subprocess.check_call(['adb', 'install', filename])


def launch_app():
    subprocess.check_call([
        'adb', 'shell',
        'am start -a android.intent.action.MAIN -n it.ecsc2024.jeopardy.exploit/.MainActivity',
    ])


@app.route('/', methods=['GET', 'POST'])
def index():
    connect_adb()
    install_app('/src/vuln.apk')

    if request.method == 'POST':
        if 'file' not in request.files:
            return Response(status=400)

        file = request.files['file']
        if file.filename == '':
            return Response(status=400)

        filename = os.path.join(app.config['UPLOAD_FOLDER'], secure_filename(file.filename))
        file.save(filename)

        install_app(filename)
        launch_app()

        return 'APK installed and launched'

    return '''
    <!doctype html>
    <title>Intent Bakery</title>
    <p>
        Upload your exploit APK here. 
        Max file size is 32MiB. 
        <br>
        Remember that the package name must be <code>it.ecsc2024.jeopardy.exploit</code> 
        and that the emulator will launch the activity at <code>it.ecsc2024.jeopardy.exploit.MainActivity</code>.
    </p>
    <form method=post enctype=multipart/form-data>
      <input type=file name=file>
      <input type=submit value=Upload>
    </form>
    '''


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
