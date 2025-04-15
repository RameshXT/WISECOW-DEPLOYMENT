from flask import Flask, Response
import subprocess

app = Flask(__name__)

@app.route('/')
def index():
    result = subprocess.run(['fortune'], capture_output=True, text=True)
    fortune = result.stdout.strip()
    return Response(fortune, mimetype='text/plain')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
