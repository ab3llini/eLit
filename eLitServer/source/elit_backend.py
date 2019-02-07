import asyncio
import websockets
import json
import sys
import os.path as op

sys.path.append(op.realpath(op.join(op.split(__file__)[0])))
from eLitServer import request_map


async def on_connect(websocket):
    await websocket.send(json.dumps(request_map['fetch_ingredients']({})))


async def handler(websocket, path):

    await on_connect(websocket)
    while True:
        rx = await websocket.recv()
        rx = json.loads(rx)
        print('[RX] -', rx)
        tx = request_map[rx['request']](rx['data'])
        print('[TX] -', tx)
        await websocket.send(json.dumps(tx))


start_server = websockets.serve(handler, '127.0.0.1', 9999)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()