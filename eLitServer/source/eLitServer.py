import sys
from http.server import SimpleHTTPRequestHandler, HTTPServer
import simplejson


class Server(SimpleHTTPRequestHandler):
    def __init__(self, request, client_address, server):
        super().__init__(request, client_address, server)

    def _set_headers(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

    def do_GET(self):
        self._set_headers()
        self.wfile.write(str.encode("<html><body><h1>hi!</h1></body></html>"))

    def do_HEAD(self):
        self._set_headers()

    def do_POST(self):
        # Doesn't do anything with posted
        self._set_headers()
        print("in post method")
        data_string = self.rfile.read(int(self.headers['Content-Length']))

        self.send_response(200)
        self.end_headers()

        data_dict = simplejson.loads(data_string)
        self.wfile.write(str.encode("<html><body><h1>POST!</h1></body></html>"))


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
