import asyncio
import websockets
import json

from requests import *

request_map = {
    'fetch_all': on_fetch_all_request,
    'update_db': on_update_request,
    'user_sign_in': on_user_sign_in_request,
    'fetch_reviews': on_fetch_reviews_request,
    'rating': on_rating_request,
    'insert_ingredient': on_insert_ingredient_request,
    'fetch_ingredients': on_fetch_ingredients_request,
}


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