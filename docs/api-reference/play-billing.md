# Play Billing

PlayBilling class for managing Google Play Billing functionalities.

## Description
The `PlayBilling` class handles Google Play Billing functionalities, including managing purchases, querying product details, and handling connection states.

## Signals


### connected

```gdscript
signal connected
``` 
Emitted when successfully connected to the billing service.

---

### disconnected

```gdscript
signal disconnected
```
Emitted when disconnected from the billing service.

---

### connect_error

```gdscript
signal connect_error(error_code: BillingResponseCode, debug_message: String)
```
Emitted when there is a connection error.

---

### query_purchases_response

```gdscript
signal query_purchases_response(purchase_list: Array[Purchase])
```
Emitted when a query for purchases is successful.

---

### query_purchase_error

```gdscript
signal query_purchases_error(error_code: BillingResponseCode, debug_message: String)
```
Emitted when a query for purchases fails.

---

### product_details_query_completed 

```gdscript
signal product_details_query_completed(product_detail_list: Array[ProductDetail])
```
Emitted when product details are successfully queried.

---

### product_details_query_error

```gdscript
signal product_details_query_error(error_code: BillingResponseCode, debug_message: String, product_id_list: Array[String])
```
Emitted when querying product details fails.

---

### purchases_updated 

```gdscript
signal purchases_updated(purchases: Array[Purchase])
```
Emitted when the purchase list is updated.

---

### purchases_updated_error

```gdscript
signal purchases_updated_error(error_code: BillingResponseCode, debug_message: String)
```
Emitted when an error occurs during purchase updates.

---

### purchase_consumed

```gdscript
signal purchase_consumed(purchase_token: String)
```
Emitted when a purchase is successfully consumed.

---

### purchase_consumption_error

```gdscript
signal purchase_consumption_error(error_code: BillingResponseCode, debug_message: String, purchase_token: String)
```
Emitted when there is an error consuming a purchase.

---

### purchase_acknowledged

```gdscript
signal purchase_acknowledged(purchase_token: String)
```
Emitted when a purchase is successfully acknowledged.

---

### purchase_acknowledgement_error

```gdscript
signal purchase_acknowledgement_error(error_code: BillingResponseCode, debug_message: String, purchase_token: String)
```
Emitted when there is an error acknowledging a purchase.

---


## Enums


### `BillingResponseCode`
Defines various billing response codes for error handling and success statuses.

- `OK`: Billing operation completed successfully.
- `USER_CANCELED`: The user canceled the operation.
- `SERVICE_UNAVAILABLE`: Billing service is not available.
- `BILLING_UNAVAILABLE`: Billing is not supported on this device.
- `ITEM_UNAVAILABLE`: The item is not available for purchase.
- `DEVELOPER_ERROR`: Invalid arguments provided to the API.
- `ERROR`: Generic error.
- `ITEM_ALREADY_OWNED`: The item has already been purchased.
- `ITEM_NOT_OWNED`: The item was not owned by the user.
- `NETWORK_ERROR`: Network issues occurred during the operation.
- `SERVICE_DISCONNECTED`: The service is disconnected.
- `FEATURE_NOT_SUPPORTED`: The feature is not supported.
- `SERVICE_TIMEOUT`: The billing service timed out.


### `ConnectionState`
Represents the connection states of the PlayBilling service.

- `DISCONNECTED`: Not connected to the billing service.
- `CONNECTING`: Attempting to connect to the billing service.
- `CONNECTED`: Successfully connected to the billing service.
- `CLOSED`: Connection to the billing service has been closed.


### `ProductType`
Categorizes product types for billing.

- `INAPP`: In-app product type.
- `SUBS`: Subscription product type.


## Methods


### start_connection

```gdscript
func start_connection(enable_auto_service_connection: bool = true) -> void:
```

Initiates a connection to the Google Play Billing service.

**Parameters:**

- `enable_auto_service_connection`: If `true`, the billing client will automatically
  attempt to reconnect when the service is disconnected. (default is true)

---

### end_connection

```gdscript
func end_connection() -> void
```

Ends the connection to the billing service.

---

### is_ready

```gdscript
func is_ready() -> bool
```

Checks if the billing plugin is ready for operations.

**Returns:**

`True` if the plugin is ready; otherwise, `False`.

---

### get_connection_state

```gdscript
func get_connection_state() -> ConnectionState
```

Retrieves the current connection state of the billing service.

**Returns:**

The current `ConnectionState` of the plugin.

---

### query_purchase

```gdscript
func query_purchase(type: ProductType) -> void
```

Queries for purchases of a specific product type.

**Parameters:**

- `type`: The type of product to query (`INAPP` or `SUBS`).

---

### query_product_details

```gdscript
func query_product_details(product_id_list: Array[String], type: ProductType) -> void
```

Queries for product details based on the provided product IDs and type.

**Parameters:**

- `product_id_list`: A list of product IDs to query.
- `type`: The type of product (`INAPP` or `SUBS`).

---

### purchase

```gdscript
func purchase(product_id: String) -> Dictionary
```

Initiates a purchase for the specified product ID.

**Parameters:**

- `product_id`: The ID of the product to purchase.

**Returns:**
A dictionary containing the purchase status.

---

### subscribe

```gdscript
func subscribe(product_id: String, selected_offer_token: String = "") -> Dictionary
```

Initiates a subscription for the specified product ID with an optional offer token.

**Parameters:**

- `product_id`: The ID of the product to subscribe to.
- `selected_offer_token`: An optional token for the selected offer (default is an empty string).

**Returns:**
A dictionary containing the subscription state.

---

### consume_purchase

```gdscript
func consume_purchase(purchase_token: String) -> void
```

Consumes a purchase using the provided purchase token.

**Parameters:**

- `purchase_token`: The token of the purchase to consume.

---

### acknowledge_purchase

```gdscript
func acknowledge_purchase(purchase_token: String) -> void
```

Acknowledges a purchase using the provided purchase token.

**Parameters:**

- `purchase_token`: The token of the purchase to acknowledge.

---

### string_to_product_type

```gdscript
static string_to_product_type(type_string: String) -> ProductType
```

Converts a string representation of a product type to the corresponding `ProductType` enum.

**Parameters:**

- `type_string`: The string representing the product type ("inapp" or "subs").

**Returns:**
The corresponding `ProductType` enum value.

---

### product_type_to_string

```gdscript
static product_type_to_string(type: ProductType) -> String
```

Converts a `ProductType` enum value to its string representation.

**Parameters:**

- `type`: The `ProductType` enum value to convert.

**Returns:**
The string representation of the `ProductType`.
