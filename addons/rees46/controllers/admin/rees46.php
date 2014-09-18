<?php
if (!defined('AREA')) { die('Access denied'); }

if ($mode == 'export_orders') {
    $shop_id = Registry::get('addons.rees46.shop_id');
    $shop_secret = Registry::get('addons.rees46.shop_secret');
    if (($shop_id == '') || ($shop_secret == '')) {
        fn_set_notification('E', 'Ошибка' ,'Для выгрузки заказов введите код и секретный ключ вашего магазина в настройках модуля.', 'I');
    } else {
        $params = array('timestamp > ' . strtotime('-6 months'), 'items_per_page' => 1000);
        $orders = fn_get_orders($params);

        $processed_orders = array();

        foreach ($orders[0] as $order) {
            $order_info = fn_get_order_info($order['order_id']);

            $items_formatted_info = array();
            foreach ($order_info['items'] as $product) {
                $product_formatted = array(
                    'id' =>  $product['product_id'],
                    'price' => $product['price'],
                    'amount' => $product['amount']
                );

                array_push($items_formatted_info, $product_formatted);
            }

            $order_formatted_info = array(
                'id' => $order_info['order_id'],
                'user_id' => $order_info['user_id'],
                'user_email' => $order_info['email'],
                'date' => $order_info['timestamp'],
                'items' => $items_formatted_info
            );

            array_push($processed_orders, $order_formatted_info);
        }

        $result = array(
            'shop_id' => $shop_id,
            'shop_secret' => $shop_secret,
            'orders' => $processed_orders
        );

        $curl = curl_init('http://api.rees46.com/import/orders.json');
        curl_setopt($curl, CURLOPT_HEADER, false);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_HTTPHEADER,
                array("Content-type: application/json"));
        curl_setopt($curl, CURLOPT_POST, true);
        curl_setopt($curl, CURLOPT_POSTFIELDS, json_encode($result));

        $json_response = curl_exec($curl);

        $status = curl_getinfo($curl, CURLINFO_HTTP_CODE);

        if ( $status != 200 ) {
            die("Error: call to URL $url failed with status $status, response $json_response, curl_error " . curl_error($curl) . ", curl_errno " . curl_errno($curl));
        }

        curl_close($curl);

        fn_set_notification('N', 'Выгрузка заказов в REES46 успешно инициирована.', '', 'I');
    }

    return array(CONTROLLER_STATUS_REDIRECT, "addons.manage");
}
