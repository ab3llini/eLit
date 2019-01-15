import sys
from http.server import SimpleHTTPRequestHandler, HTTPServer
import simplejson
import json
from typing import Dict
from database_classes import *


class Server(SimpleHTTPRequestHandler):
    def __init__(self, request, client_address, server):
        super().__init__(request, client_address, server)
        self.request_map = {
            'fetch_all': self.__on_fetch_all_request,
            'update_db': self.__on_update_request
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
        response = self.request_map[data_dict['request']](data_dict)
        self.wfile.write(json.dumps(response).encode())

    # Utilities functions for handle the requests
    @staticmethod
    def __on_fetch_all_request(data: Dict) -> Dict:
        drinks = Drink.objects
        payload = {
            'request': 'fetch_all',
            'data': [x.to_dict() for x in drinks]
        }
        return payload

    def __on_update_request(self, data: Dict) -> Dict:
        pass


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
