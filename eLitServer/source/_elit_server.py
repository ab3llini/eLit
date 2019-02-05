import os.path as op
import sys

from aiohttp import web
import json

sys.path.append(op.realpath(op.join(op.split(__file__)[0])))
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


async def on_post_request(request):
    data_dict = await request.json()
    sender = request.transport.get_extra_info('peername')
    host, port = sender or (None, None)
    print(f'Received request "{data_dict["request"]}" from ip: {host} at port: {port}')
    response = request_map[data_dict['request']](data_dict['data'])
    status_code = response['status_code']
    return web.Response(status=status_code, text=json.dumps(response))


if __name__ == '__main__':
    app = web.Application()
    app.add_routes([
        web.post('/', on_post_request),
        web.static('/assets', '../resources/assets/', show_index=False)
    ])

    args = sys.argv

    if len(args) == 3:
        web.run_app(app, host=args[1], port=int(args[2]))
    elif len(args) == 2:
        web.run_app(app, host=args[1], port=80)
    else:
        web.run_app(app, host='localhost', port=80)
