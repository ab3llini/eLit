import sys
from http.server import SimpleHTTPRequestHandler, HTTPServer
import simplejson
import json
from typing import Dict
from database_classes import *
from requests import *


class Server(SimpleHTTPRequestHandler):
    request_map = {
        'fetch_all': on_fetch_all_request,
        'update_db': on_update_request,
        'user_sign_in': on_user_sign_in_request
    }

    def _set_headers(self):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()

    def do_GET(self):
        self._set_headers()
        self.wfile.write(str.encode("<html><body><h1>hi!</h1></body></html>"))

    def do_HEAD(self):
        self._set_headers()

    def do_POST(self):
        # Doesn't do anything with posted
        self._set_headers()
        print(self.headers)
        data_string = self.rfile.read(int(self.headers['Content-Length']))
        print('Received:', data_string)
        data_dict = simplejson.loads(data_string)
        print('Parsed:', data_dict)
        print(self.request_map)
        response = self.request_map[data_dict['request']](data_dict['data'])
        self.wfile.write(json.dumps(response).encode())


def start_server(ip: str, port: int):
    server_address = (ip, port)
    httpd = HTTPServer(server_address, Server)
    print('Starting httpd...')
    httpd.serve_forever()


if __name__ == '__main__':
    args = sys.argv
    if len(args) != 3:
        start_server('localhost', 80)
    else:
        start_server(args[1], int(args[2]))
