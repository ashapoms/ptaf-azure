#!/opt/waf/python/bin/python

import json  # to avoid bug in requests lib
import requests


AUTH_HEADER = {'Authorization': 'Basic YXBpYzpwMHMxdDF2Mw=='}
API_ROOT = 'https://40.76.50.33:8443/api/waf/v2/'


def endpoint(name):
    return API_ROOT + name


def create_alias(name, alias_type):
    return json.loads(
        requests.post(
            endpoint('interface_aliases'),
            headers=AUTH_HEADER,
            json={'name': name, 'type': alias_type},
            verify=False
        ).content
    )


def alias_by_name(name):
    return next(
        alias['id'] for alias in json.loads(
            requests.get(
                endpoint('interface_aliases'),
                headers=AUTH_HEADER,
                verify=False
            ).content
        )['items']
        if alias['name'] == name
    )


def gateway_id():
    print(json.loads(
        requests.get(
            endpoint('gateways'),
            headers=AUTH_HEADER,
            verify=False
        ).content))
    return json.loads(
        requests.get(
            endpoint('gateways'),
            headers=AUTH_HEADER,
            verify=False
        ).content
    )['items'][0]['id']


def attach_alias(gateway, interface, alias):
    return json.loads(
        requests.patch(
            endpoint(
                'gateways/{gateway}/intefaces/{interface}'.format(
                    gateway=gateway,
                    interface=interface
                )
            ),
            headers=AUTH_HEADER,
            json={'aliaces': alias},
            verify=False
        ).content
    )


def activate_gateway(gateway_id):
    return json.loads(
        requests.patch(
            endpoint(
                'gateways/{gateway_id}'.format(
                    gateway_id=gateway_id,
                )
            ),
            headers=AUTH_HEADER,
            json={'active': True},
            verify=False
        ).content
    )

if __name__ == '__main__':
    gateway = gateway_id()
    mgmt = alias_by_name('mgmt')
    attach_alias(gateway, 'eth0', mgmt)
    activate_gateway(gateway)
