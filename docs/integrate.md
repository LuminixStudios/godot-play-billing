# Integrate Play Billing

Before proceeding with the integration, please ensure that you have completed the following steps:

1. **Set Up Your Google Play Console Account:** Make sure your app is created and configured in the Google Play Console.
2. **Configure In-App Purchase Products:** Set up the required in-app purchase products in the Google Play Console, as these will be necessary for testing and implementing the billing functionality.

> Note: The Google Play billing server only connects with APKs downloaded from the Play Store. Ensure you have created at least an internal release in the Play Console so you can download the app from the Play Store for testing purposes.

## Add PlayBilling Node to your scene

Once the plugin is enabled, the [PlayBilling](api-reference/play-billing.md) node will appear in the Node Hierarchy.

![Add PlayBilling Node](assets/add_play_billing.png)

Simply add the [PlayBilling](api-reference/play-billing.md) node to your scene to begin integrating Google Play Billing.


## Initialise

To get started, obtain a reference to the [PlayBilling](api-reference/play-billing.md) node:

```gdscript
@onready var _play_billing: PlayBilling = $PlayBilling
```

Use [start_connection](api-reference/play-billing.md#start_connection) to establish a connection to the Play Billing server:

```gdscript linenums="1"
@onready var _play_billing: PlayBilling = $PlayBilling

func _ready():
	_play_billing.start_connection()
```

If you want to manually handle reconnection if connection is lost.
```gdscript linenums="1"
func _ready():
	_play_billing.start_connection(enable_auto_service_connection = false)
```

### Connection Success

Upon a successful connection, the [PlayBilling](api-reference/play-billing.md) node emits a [connected](api-reference/play-billing.md#connected) signal.

After the connection is established, query the product details. **Important:** A product query must be completed successfully before calling [purchase](api-reference/play-billing.md#purchase) or [subscribe](api-reference/play-billing.md#subscribe); otherwise, they will return an error.

[query_product_details](api-reference/play-billing.md#query_product_details) function accepts two arguments:

1. Array of product IDs.
2. [ProductType](api-reference/play-billing.md#producttype) enum.

```gdscript
func _on_play_billing_connected() -> void:
    _play_billing.query_product_details(["product_ids"], PlayBilling.ProductType.INAPP)
```

### Connection Error

Upon failed connection, the [PlayBilling](api-reference/play-billing.md) node emits a `connect_error` signal. Use the `error_code` and `debug_message` for logging.

```gdscript
func _on_play_billing_connect_error(error_code: PlayBilling.BillingResponseCode, debug_message: String) -> void:
	print(error_code, debug_message)
```


## Displaying Available Products

Once the product query is successful, the [product_details_query_completed](api-reference/play-billing.md#product_details_query_completed) signal is emitted. If the query fails, the [product_details_query_error](./api-reference/play-billing.md#product_details_query_error) signal is emitted instead.

```gdscript linenums="1"
func _on_play_billing_product_details_query_completed(product_detail_list: Array[ProductDetail]) -> void:
	print(product_detail_list)


func _on_play_billing_product_details_query_error(error_code: PlayBilling.BillingResponseCode, debug_message: String, product_id_list: Array[String]) -> void:
	print(error_code, debug_message, product_id_list)
```

The signal emits list of [ProductDetail](api-reference/models/product-detail/index.md). Use the information provided in each [ProductDetail](api-reference/models/product-detail/index.md) to display relevant product information for users.


## Launch Purchase Flow


### Purchasing a Product

To launch purchase flow, use the [purchase](./api-reference/play-billing.md#purchase) method. This method requires the `product_id` which is the unique identifier for the product.

```gdscript
_play_billing.purchase("product_id")
```

### Subscribing to a Product

To launch subscription flow, use the [subscribe](./api-reference/play-billing.md#subscribe) method. This method requires the `product_id` which is the unique identifier for the product, and an optional `offer_token`.

```gdscript
_play_billing.subscribe("product_id", "offer_token")
```

## Processing Purchased Items

After a succesfull [purchase](./api-reference/play-billing.md#purchase) or [subscribe](./api-reference/play-billing.md#subscribe) call, the payment flow will emit the [purchases_updated](./api-reference/play-billing.md#purchases_updated) signal. If payment flow fails [purchases_updated_error](./api-reference/play-billing.md#purchases_updated_error) signal is emitted instead.

```gdscript linenums="1"
func _on_play_billing_purchases_updated(purchases: Array[Purchase]) -> void:
	for purchase in purchases:
		_process_purchase(purchase)


func _on_play_billing_purchases_updated_error(error_code: PlayBilling.BillingResponseCode, debug_message: String) -> void:
	print(error_code, debug_message)
```


### Acknowledge Products

Products need to be acknowledged to complete the billing cycle. Use the [acknowledge_purchase](./api-reference/play-billing.md#acknowledge_purchase) method to acknowledge purchases.

```gdscript linenums="1"
func _process_purchase(purchase: Purchase) -> void:
# Save purchase for future verification.
	if purchase.purchase_state == Purchase.PurchaseState.PURCHASED:
		if "product_id" in purchase.product_ids and !purchase.is_acknowledged:
			_play_billing.acknowledge_purchase(purchase.purchase_token)
```

Once a product is successfully acknowledged, the [purchase_acknowledged](./api-reference/play-billing.md#purchase_acknowledged) signal is emitted. If an error occurs, the [purhase_acknowledgement_error](./api-reference/play-billing.md#purchase_acknowledgement_error) signal is emitted instead.

```gdscript linenums="1"
func _on_play_billing_purchase_acknowledged(purchase_token: String) -> void:
	# _purchase is the saved list of purchases.
	for purchase: Purchase in _purchases:
		if purchase_token == purchase.purchase_token:
			if "product_id" in purchase.product_ids:
				# Award item to user.


func _on_play_billing_purchase_acknowledgement_error(error_code: PlayBilling.BillingResponseCode, debug_message: String, purchase_token: String) -> void:
	print(error_code, debug_message, purchase_token)
```


### Consume Products

Consumable products, such as coins, can be purchased multiple times. To allow repeat purchases, consume the product after a successful purchase by calling [consume_purchase](./api-reference/play-billing.md#consume_purchase).  This automatically acknowledges the purchase, enabling the user to buy the product again.

```gdscript linenums="1"
func _process_purchase(purchase: Purchase) -> void:
	# Save purchase for future verification.
	if purchase.purchase_state == Purchase.PurchaseState.PURCHASED:
		if "product_id" in purchase.product_ids:
			_play_billing.consume_purchase(purchase.purchase_token)
```

Once a product is successfully consumed, the [purchase_consumed](./api-reference/play-billing.md#purchase_consumed) signal is emitted. If an error occurs, the [purhase_consumption_error](./api-reference/play-billing.md#purchase_consumption_error) signal is emitted instead.

```gdscript linenums="1"
func _on_play_billing_purchase_consumed(purchase_token: String) -> void:
	# _purchase is the saved list of purchases.
	for purchase: Purchase in _purchases:
		if purchase_token == purchase.purchase_token:
			if "product_id" in purchase.product_ids:
				# Award product to user.


func _on_play_billing_purchase_consumption_error(error_code: PlayBilling.BillingResponseCode, debug_message: String, purchase_token: String) -> void:
	print(error_code, debug_message, purchase_token)
```
**Note**: Consumable products do not require a separate call to [acknowledge_purchase](./api-reference/play-billing.md#acknowledge_purchase) method as, [consume_purchase](./api-reference/play-billing.md#consume_purchase) automatically acknowledges them.


## Handling pending Purchases

Purchases can happen outside the app due to poor connection, pending transactions or various other reasons. It is necessary to handle such purchases. Call [query_purchase](./api-reference/play-billing.md#query_purchase) method to query purchases. [query_purchase](./api-reference/play-billing.md#query_purchase) requires [ProductType](./api-reference/play-billing.md#producttype) argument. Generally you would like to query purchase after product details query is completed or when billing client is connected.

```gdscript
_play_billing.query_purchase(PlayBilling.ProductType.INAPP)
```

After successful query it emits [query_purchases_response](./api-reference/play-billing.md#query_purchases_response). If error occurs [query_purchase_error](./api-reference/play-billing.md#query_purchase_error) is emitted instead.

```gdscript linenums="1"
func _on_play_billing_query_purchases_response(purchase_list: Array[Purchase]) -> void:
	for purchase in purchase_list:
		_process_purchase(purchase)


func _on_play_billing_query_purchases_error(error_code: PlayBilling.BillingResponseCode, debug_message: String) -> void:
	print(error_code, debug_message)
```