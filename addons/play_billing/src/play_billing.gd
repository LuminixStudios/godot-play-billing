# MIT License
# 
# Copyright (c) 2024-present Luminix Studios
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

extends Node


## PlayBilling class for managing Google Play Billing functionalities.
##
## This class handles the Google Play Billing functionality, including
## managing purchases, querying product details, and handling connection states.
class_name PlayBilling


static var _plugin

## Emitted when successfully connected to the billing service.
signal connected
## Emitted when disconnected from the billing service.
signal disconnected
## Emitted when there is a connection error.
signal connect_error(error_code: BillingResponseCode, debug_message: String)
## Emitted when a query for purchases is successful.
signal query_purchases_response(purchase_list: Array[Purchase])
## Emitted when a query for purchases fails.
signal query_purchases_error(error_code: BillingResponseCode, debug_message: String)
## Emitted when product details are successfully queried.
signal product_details_query_completed(product_detail_list: Array[ProductDetail])
## Emitted when querying product details fails.
signal product_details_query_error(error_code: BillingResponseCode, 
	debug_message: String, product_id_list: Array[String])
## Emitted when the purchase list is updated.
signal purchases_updated(purchases: Array[Purchase])
## Emitted when an error occurs during purchase updates.
signal purchases_updated_error(error_code: BillingResponseCode, debug_message: String)
## Emitted when a purchase is successfully consumed.
signal purchase_consumed(purchase_token: String)
## Emitted when there is an error consuming a purchase.
signal purchase_consumption_error(error_code: BillingResponseCode, 
	debug_message: String, purchase_token: String)
## Emitted when a purchase is successfully acknowledged.
signal purchase_acknowledged(purchase_token: String)
## Emitted when there is an error acknowledging a purchase.
signal purchase_acknowledgement_error(error_code: BillingResponseCode, 
	debug_message: String, purchase_token: String)


## Enum to define various billing response codes for error handling and success statuses.
enum BillingResponseCode {
	OK = 0,                   ## Billing operation completed successfully.
	USER_CANCELED = 1,       ## The user canceled the operation.
	SERVICE_UNAVAILABLE = 2,  ## Billing service is not available.
	BILLING_UNAVAILABLE = 3,  ## Billing is not supported on this device.
	ITEM_UNAVAILABLE = 4,     ## The item is not available for purchase.
	DEVELOPER_ERROR = 5,      ## Invalid arguments provided to the API.
	ERROR = 6,                ## Generic error.
	ITEM_ALREADY_OWNED = 7,   ## The item has already been purchased.
	ITEM_NOT_OWNED = 8,       ## The item was not owned by the user.
	NETWORK_ERROR = 12,       ## Network issues occurred during the operation.
	SERVICE_DISCONNECTED = -1, ## The service is disconnected.
	FEATURE_NOT_SUPPORTED = -2,## The feature is not supported.
	SERVICE_TIMEOUT = -3       ## The billing service timed out.
}


## Enum to represent the connection states of the PlayBilling service.
enum ConnectionState {
	DISCONNECTED = 0,  ## Not connected to the billing service.
	CONNECTING = 1,    ## Attempting to connect to the billing service.
	CONNECTED = 2,     ## Successfully connected to the billing service.
	CLOSED = 3,        ## Connection to the billing service has been closed.
}


## Enum to categorize product types for billing.
enum ProductType {
	INAPP,  ## In-app product type.
	SUBS,   ## Subscription product type.
}


## Converts a string representation of a product type 
##to the corresponding ProductType enum.[br][br]
##
## [param type_string] The string representing 
##the product type ("inapp" or "subs").[br][br]
##
## Returns the corresponding ProductType enum value.
static func string_to_product_type(type_string: String) -> ProductType:
	var type: ProductType
	
	if type_string == "inapp":
		type = ProductType.INAPP
	elif type_string == "subs":
		type = ProductType.SUBS
	else:
		push_error("Invalid type_string.")
	
	return type


## Converts a ProductType enum value to its string representation.[br][br]
##
## [param type] The ProductType enum value to convert.[br][br]
##
## Returns the string representation of the ProductType.
static func product_type_to_string(type: ProductType) -> String:
	var type_string: String
	match type:
		ProductType.INAPP:
			type_string = "inapp"
		ProductType.SUBS:
			type_string = "subs"
	return type_string


func _init() -> void:
	if (OS.get_name() == "Android"):
		if (Engine.has_singleton("GodotPlayBilling")):
			_plugin = Engine.get_singleton("GodotPlayBilling")
			
			_plugin.connected.connect(_connected)
			_plugin.disconnected.connect(_disconnected)
			_plugin.connect_error.connect(_connect_error)
			_plugin.query_purchases_response.connect(_query_purchases_response)
			_plugin.query_purchases_error.connect(_query_purchases_error)
			_plugin.product_details_query_completed.connect(_product_details_query_completed)
			_plugin.product_details_query_error.connect(_product_details_query_error)
			_plugin.purchases_updated.connect(_purchases_updated)
			_plugin.purchases_updated_error.connect(_purchases_updated_error)
			_plugin.purchase_consumed.connect(_purchase_consumed)
			_plugin.purchase_consumption_error.connect(_purchase_consumption_error)
			_plugin.purchase_acknowledged.connect(_purchase_acknowledged)
			_plugin.purchase_acknowledgement_error.connect(_purchase_acknowledgement_error)
			
			print("GodotPlayBilling plugin initialized successfully.")
		else:
			printerr("GodotPlayBilling not found. Make sure you have enabled 'Gradle Build' and the GodotPlayBilling plugin in your Android export settings! IAP will not work.")
	else:
		printerr("Google Play Billing is only supported on Android. The current platform does not support it.")


## Initiates a connection to the Google Play Billing service.
##
## If [param enable_auto_service_connection] is true, the plugin will automatically
## reconnect to the billing service if the connection is lost (for example, due to
## Play Store updates or process restarts).
##
## Call this before querying products, purchases, or launching the billing flow.
func start_connection(enable_auto_service_connection: bool = true) -> void:
	if _plugin:
		_plugin.startConnection(enable_auto_service_connection)


## Ends the connection to the billing service.
func end_connection() -> void:
	if _plugin:
		_plugin.endConnection()


## Checks if the billing plugin is ready for operations.[br][br]
## Returns True if the plugin is ready; otherwise, False.
func is_ready() -> bool:
	if _plugin:
		return _plugin.isReady()
	return false


## Retrieves the current connection state of the billing service.[br][br]
##
## Returns the current [enum ConnectionState] of the plugin.
func get_connection_state() -> ConnectionState:
	if _plugin:
		return _plugin.getConnectionState()
	return ConnectionState.CLOSED


## Queries for purchases of a specific product type.[br][br]
## [param type] The type of product to query (INAPP or SUBS).
func query_purchase(type: ProductType) -> void:
	if _plugin:
		_plugin.queryPurchase(product_type_to_string(type))


## Queries for product details based on the provided product IDs and type.[br][br]
## [param product_id_list] A list of product IDs to query.
## [param type] The type of product (INAPP or SUBS).
func query_product_details(product_id_list: Array[String], type: ProductType) -> void:
	if _plugin:
		_plugin.queryProductDetails(product_id_list, product_type_to_string(type))


## Initiates a purchase for the specified product ID.[br][br]
## [param product_id] The ID of the product to purchase.[br][br]
## Returns a dictionary containing purchase status.
func purchase(product_id: String) -> Dictionary:
	if _plugin:
		return _plugin.purchase(product_id)
	return {}


## Initiates a subscription for the specified product ID with an optional offer token.[br][br]
## [param product_id] The ID of the product to subscribe to.[br]
## [param selected_offer_token] An optional token for the selected offer 
## (default is an empty string).[br]br]
## Returns a dictionary containing subscription state.
func subscribe(product_id: String, selected_offer_token: String = "") -> Dictionary:
	if _plugin:
		return _plugin.subscribe(product_id, selected_offer_token)
	return {}


## Consumes a purchase using the provided purchase token.[br][br]
## [param purchase_token] The token of the purchase to consume.
func consume_purchase(purchase_token: String) -> void:
	if _plugin:
		_plugin.consumePurchase(purchase_token)


## Acknowledges a purchase using the provided purchase token.[br][br]
## [param purchase_token] The token of the purchase to acknowledge.
func acknowledge_purchase(purchase_token: String) -> void:
	if _plugin:
		_plugin.acknowledgePurchase(purchase_token)


func _connected() -> void: 
	connected.emit()


func _disconnected() -> void:
	disconnected.emit()


func _connect_error(
	error_code: BillingResponseCode, debug_message: String) -> void:
	connect_error.emit(error_code, debug_message) 


func _query_purchases_response(purchase_list: String) -> void:
	query_purchases_response.emit(
		Utility.from_Json_to_Purchase_List(purchase_list)
	)


func _query_purchases_error(error_code: BillingResponseCode, debug_message: String) -> void:
	query_purchases_error.emit(error_code, debug_message)


func _product_details_query_completed(product_detail_list: String) -> void:
	product_details_query_completed.emit(
		Utility.from_Json_to_ProductDetails_List(product_detail_list)
	)


func _product_details_query_error(error_code: BillingResponseCode, 
	debug_message: String, product_id_list: Array[String]) -> void:
	product_details_query_error.emit(error_code, debug_message, product_id_list)


func _purchases_updated(purchases: String) -> void:
	purchases_updated.emit(Utility.from_Json_to_Purchase_List(purchases))


func _purchases_updated_error(error_code: BillingResponseCode, 
	debug_message: String) -> void:
	purchases_updated_error.emit(error_code, debug_message)


func _purchase_consumed(purchase_token: String) -> void:
	purchase_consumed.emit(purchase_token)


func _purchase_consumption_error(error_code: BillingResponseCode, 
	debug_message: String, purchase_token: String) -> void:
	purchase_consumption_error.emit(error_code, debug_message, purchase_token)


func _purchase_acknowledged(purchase_token: String) -> void:
	purchase_acknowledged.emit(purchase_token)


func _purchase_acknowledgement_error(error_code: BillingResponseCode, 
	debug_message: String, purchase_token: String) -> void:
	purchase_acknowledgement_error.emit(error_code, debug_message, purchase_token)
