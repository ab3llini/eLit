import asyncio
import websockets
import json
import sys
import os.path as op
from threading import Thread


sys.path.append(op.realpath(op.join(op.split(__file__)[0])))
from eLitServer import request_map


class Backend:

    def __init__(self, server, port):
        self.port = port
        self.server = server

    async def on_connect(self, websocket):

        print('New connection established, sending ingredients & drinks')

        await websocket.send(json.dumps(request_map['fetch_ingredients']({})))
        await websocket.send(json.dumps(request_map['fetch_drinks']({})))

    async def handler(self, websocket, path):
        await self.on_connect(websocket)
        while True:
            rx = await websocket.recv()
            rx = json.loads(rx)
            print('<-----', rx)
            tx = request_map[rx['request']](rx['data'])
            print('----->', tx)
            await websocket.send(json.dumps(tx))

    def _run(self):

        loop = asyncio.new_event_loop()
        asyncio.set_event_loop(loop)
        start_server = websockets.serve(self.handler, self.server, self.port)
        asyncio.get_event_loop().run_until_complete(start_server)
        asyncio.get_event_loop().run_forever()

    def start(self):

        print('Starting backend on port', self.port)

        t = Thread(target=self._run)
        t.start()

        return t








