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


extends Object


## Represents a single in-app purchase, encapsulating details
## such as order ID, product IDs, purchase state, and more.
##
## This class allows initialization of purchase details from JSON data
## and includes methods to represent the purchase as a string for easy
## logging or debugging. Each purchase object contains essential properties
## to track and verify in-app transactions and their state.
class_name Purchase


## Developer-defined payload associated with this purchase.
var developer_payload: String

## Unique order ID associated with this purchase.
var order_id: String

## Original JSON string representing the purchase details as provided by the billing API.
var original_json: String

## Package name of the application where the purchase was made.
var package_name: String

## Array of product IDs purchased in this transaction.
var product_ids: Array[String]

## Token uniquely identifying this purchase, used for validation and acknowledgment.
var purchase_token: String

## Quantity of the purchased item(s).
var quantity: int

## Digital signature for verifying the purchase integrity and authenticity.
var signature: String

## Indicates whether the purchase has been acknowledged by the app.
var is_acknowledged: bool

## Indicates if the purchase is set to auto-renew (for subscriptions).
var is_auto_renewing: bool

## Timestamp of the purchase, in milliseconds.
var purchase_time: float

## State of the purchase, as defined in the PurchaseState enum.
var purchase_state: PurchaseState


## Initializes the Purchase object with provided purchase details.[br][br]
##
## [param developer_payload]: Developer-defined payload for validation purposes.[br]
## [param order_id]: Unique order ID.[br]
## [param original_json]: JSON string of the purchase details.[br]
## [param package_name]: Application's package name.[br]
## [param product_ids]: Array of product IDs in this purchase.[br]
## [param purchase_token]: Unique token for this purchase.[br]
## [param quantity]: Quantity of items purchased.[br]
## [param signature]: Signature for integrity verification.[br]
## [param is_acknowledged]: Boolean indicating if the purchase is acknowledged.[br]
## [param is_auto_renewing]: Boolean indicating if the purchase is auto-renewing.[br]
## [param purchase_time]: Timestamp of the purchase.[br]
## [param purchase_state]: Purchase state as defined in [enum PurchaseState].[br]
func _init(developer_payload: String, order_id: String, original_json: String, 
			package_name: String, product_ids: Array[String], purchase_token: String, 
			quantity: int, signature: String, is_acknowledged: bool, 
			is_auto_renewing: bool, purchase_time: int, purchase_state: PurchaseState):
	self.developer_payload = developer_payload
	self.order_id = order_id
	self.original_json = original_json
	self.package_name = package_name
	self.product_ids = product_ids
	self.purchase_token = purchase_token
	self.quantity = quantity
	self.signature = signature
	self.is_acknowledged = is_acknowledged
	self.is_auto_renewing = is_auto_renewing
	self.purchase_time = purchase_time
	self.purchase_state = purchase_state

## Static method to create a [class Purchase] instance from JSON data.[br][br]
##
## [param data]: JSON-like Variant containing purchase details.[br][br]
## Returns a [class Purchase] object initialized with JSON data.
static func from_json(data: Variant) -> Purchase:
	var ids = data.get("product_ids", [])
	var ids_array: Array[String] = []
	
	ids_array.append_array(ids)
	
	return Purchase.new(
		data.get("developer_payload", ""),
		data.get("order_id", ""),
		data.get("original_json", ""),
		data.get("package_name", ""),
		ids_array,
		data.get("purchase_token", ""),
		data.get("quantity", 0),
		data.get("signature", ""),
		data.get("is_acknowledged", false),
		data.get("is_auto_renewing", false),
		data.get("purchase_time", 0),
		data.get("purchase_state", 0)
	)


## Provides a detailed string representation of the purchase object, listing all fields.
func to_string() -> String:
	var details: Array = []
	details.append("Purchase:")
	details.append(" - Developer Payload: " + developer_payload)
	details.append(" - Order ID: " + order_id)
	details.append(" - Original JSON: " + original_json)
	details.append(" - Package Name: " + package_name)
	details.append(" - Product IDs: " + str(product_ids))
	details.append(" - Purchase Token: " + purchase_token)
	details.append(" - Quantity: " + str(quantity))
	details.append(" - Signature: " + signature)
	details.append(" - Acknowledged: " + str(is_acknowledged))
	details.append(" - Auto Renewing: " + str(is_auto_renewing))
	details.append(" - Purchase Time: " + str(purchase_time))
	details.append(" - Purchase State: " + str(purchase_state))
	
	return "\n".join(details)


## Enum representing potential states of a purchase.
enum PurchaseState {
	## Unspecified purchase state.
	UNSPECIFIED_STATE = 0,
	
	## Purchase has been completed and approved.
	PURCHASED = 1,
	
	## Purchase is pending approval or completion.
	PENDING = 2,
}
