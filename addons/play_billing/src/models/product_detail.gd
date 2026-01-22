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


## Represents the details of a product in the Play Billing system.
##
## The ProductDetail class holds various attributes related to a
## product, including its name, description, pricing, and more.
class_name ProductDetail


var name: String ## The name of the product.
var description: String ## A brief description of the product.
var one_time_purchase_offer_details: OneTimePurchaseOfferDetails ## Details about one-time purchase offers.
var product_id: String ## The unique identifier for the product.
var product_type: PlayBilling.ProductType ## The type of the product (e.g., in-app product, subscription).
var subscription_offer_detail_list: Array[SubscriptionOfferDetails] ## List of subscription offer details.
var title: String ## The title of the product.


## Initializes a new instance of ProductDetail.
##
## This constructor takes the essential parameters for creating a product
## detail instance, including name, description, and other relevant data.[br][br]
##
## [param name] The name of the product.[br]
## [param description] A brief description of the product.[br]
## [param one_time_purchase_offer_details] Details about one-time purchase offers.[br]
## [param product_id] The unique identifier for the product.[br]
## [param product_type] The type of the product, converted from string to enum.[br]
## [param subscription_offer_detail_list] List of subscription offer details.[br]
## [param title] The title of the product.[br]
func _init(name: String, description: String, 
	one_time_purchase_offer_details: OneTimePurchaseOfferDetails, 
	product_id: String, product_type: String, 
	subscription_offer_detail_list: Array[SubscriptionOfferDetails], 
	title: String):
	self.name = name
	self.description = description
	self.one_time_purchase_offer_details = one_time_purchase_offer_details
	self.product_id = product_id
	self.product_type = PlayBilling.string_to_product_type(product_type)
	self.subscription_offer_detail_list = subscription_offer_detail_list
	self.title = title

## Returns a string representation of the ProductDetail instance.
func to_string() -> String:
	var details: String = "ProductDetail:\n"
	details += "  Title: %s\n" % title
	details += "  Name: %s\n" % name
	details += "  Description: %s\n" % description
	details += "  Product ID: %s\n" % product_id
	details += "  Product Type: %s\n" % PlayBilling.product_type_to_string(product_type)
	details += "  One-Time Purchase Offer Details: %s\n" % (get("one_time_purchase_offer_details").to_string() if one_time_purchase_offer_details != null else "None")
	details += "  Subscription Offer Details List:\n"
	for sub_offer in subscription_offer_detail_list:
		details += "    - %s\n" % sub_offer.to_string()
	return details


## Static method to create a ProductDetail instance from JSON data.
##
## This method parses the JSON data and initializes a new ProductDetail
## instance with the parsed values.[br][br]
##
## [param data] The JSON data as a Variant.[br][br]
##
## Returns a new instance of ProductDetail created from the JSON data.[br]
static func from_json(data: Variant) -> ProductDetail:
	
	var offer_string = data.get("one_time_purchase_offer_details", null)
	var offer: OneTimePurchaseOfferDetails = null
	if offer_string != null:
		offer = OneTimePurchaseOfferDetails.from_json(offer_string)
	
	var subs_offer_string = data.get("subscription_offer_detail_list", [])
	var subs_offer: Array[SubscriptionOfferDetails] = []
	if subs_offer_string != []:
		subs_offer = Utility.from_Json_to_SubscriptionOfferDetails_List(subs_offer_string)
	
	return ProductDetail.new(
		data.get("name", ""),
		data.get("description", ""),
		offer,
		data.get("product_id", ""),
		data.get("product_type", 0),
		subs_offer,
		data.get("title", "")
	)


## Represents the pricing phase of a product.
##
## This class holds details about the billing cycle, pricing, and
## recurrence mode for a pricing phase.
class PricingPhase:
	
	var billing_cycle_count: int ## The number of billing cycles.
	var billing_period: String ## The billing period (e.g., monthly).
	var formatted_price: String ## The price formatted for display.
	var price_amount_micros: int ## The price amount in micros.
	var price_currency_code: String ## The currency code for the price.
	var recurrence_mode: int ## The recurrence mode for billing.
	
	
	## Initializes a new instance of PricingPhase.[br][br]
	##
	## [param billing_cycle_count] Number of billing cycles.[br]
	## [param billing_period] The period of billing (e.g., monthly).[br]
	## [param formatted_price] The price formatted for display.[br]
	## [param price_amount_micros] The price amount in micros.[br]
	## [param price_currency_code] The currency code for the price.[br]
	## [param recurrence_mode] The recurrence mode for billing.[br]
	func _init(billing_cycle_count: int, billing_period: String, 
			formatted_price: String, price_amount_micros: int, 
			price_currency_code: String, recurrence_mode: int
		):
		self.billing_cycle_count = billing_cycle_count
		self.billing_period = billing_period
		self.formatted_price = formatted_price
		self.price_amount_micros = price_amount_micros
		self.price_currency_code = price_currency_code
		self.recurrence_mode = recurrence_mode
	
	
	## Static method to create a PricingPhase instance from JSON data.[br][br]
	##
	## [param data] The JSON data as a Variant.[br][br]
	## Returns a new instance of PricingPhase created from the JSON data.
	static func from_json(data: Variant) -> PricingPhase:
		return PricingPhase.new(
			data.get("billing_cycle_count", 0),
			data.get("billing_period", ""),
			data.get("formatted_price", ""),
			data.get("price_amount_micros", 0),
			data.get("price_currency_code", ""),
			data.get("recurrence_mode", 0)
		)
	
	## Returns a string representation of the PricingPhase instance.
	func to_string() -> String:
		return "PricingPhase(billing_cycle_count=%d, billing_period=%s, formatted_price=%s, price_amount_micros=%d, price_currency_code=%s, recurrence_mode=%d)" % [
			billing_cycle_count, billing_period, formatted_price, price_amount_micros, price_currency_code, recurrence_mode
		]



## Represents details about a one-time purchase offer.
##
## The OneTimePurchaseOfferDetails class holds pricing information
## related to a one-time purchase offer.
class OneTimePurchaseOfferDetails:
	
	var formatted_price: String ## The formatted price for display.
	var price_amount_micros: float ## The price amount in micros.
	var price_currency_code: String ## The currency code for the price.
	
	
	## Initializes a new instance of OneTimePurchaseOfferDetails.[br][br]
	##
	## [param formatted_price] The formatted price for display.[br]
	## [param price_amount_micros] The price amount in micros.[br]
	## [param price_currency_code] The currency code for the price.[br]
	func _init(
		formatted_price: String, 
		price_amount_micros: float, 
		price_currency_code: String):
		self.formatted_price = formatted_price
		self.price_amount_micros = price_amount_micros
		self.price_currency_code = price_currency_code
	
	
	## Static method to create a OneTimePurchaseOfferDetails instance from JSON data.[br][br]
	##
	## [param data] The JSON data as a Variant.[br][br]
	## Returns a new instance of OneTimePurchaseOfferDetails created from the JSON data.
	static func from_json(data: Variant) -> OneTimePurchaseOfferDetails:
		return OneTimePurchaseOfferDetails.new(
			data.get("formatted_price", ""),
			data.get("price_amount_micros", 0),
			data.get("price_currency_code", "")
		)
	
	## Returns a string representation of the OneTimePurchaseOfferDetails instance.
	func to_string() -> String:
		return "OneTimePurchaseOfferDetails(formatted_price=%s, price_amount_micros=%.2f, price_currency_code=%s)" % [
			formatted_price, price_amount_micros, price_currency_code
		]


## Represents the details of an installment plan.
##
## The InstallmentPlanDetails class holds information about the
## commitment payments for an installment plan.
class InstallmentPlanDetails:
	var installment_plan_commitment_payments_count: int
	var subsequent_installment_plan_commitment_payments_count: int
	
	
	## Initializes a new instance of InstallmentPlanDetails.[br][br]
	##
	## [param installment_plan_commitment_payments_count] Number of commitment payments.
	## [param subsequent_installment_plan_commitment_payments_count] Number of subsequent commitment payments.[br]
	func _init(
		installment_plan_commitment_payments_count: int, 
		subsequent_installment_plan_commitment_payments_count: int):
		self.installment_plan_commitment_payments_count = installment_plan_commitment_payments_count
		self.subsequent_installment_plan_commitment_payments_count = subsequent_installment_plan_commitment_payments_count
	
	## Static method to create an InstallmentPlanDetails instance from JSON data.[br][br]
	##
	## [param data] The JSON data as a Variant.[br][br]
	## Returns a new instance of InstallmentPlanDetails created from the JSON data.
	static func from_json(data: Variant) -> InstallmentPlanDetails:
		return InstallmentPlanDetails.new(
			data.get("installment_plan_commitment_payments_count", 0),
			data.get("subsequent_installment_plan_commitment_payments_count", 0)
		)
	
	## Returns a string representation of the InstallmentPlanDetails instance.
	func to_string() -> String:
		return "InstallmentPlanDetails(installment_plan_commitment_payments_count=%d, subsequent_installment_plan_commitment_payments_count=%d)" % [
			installment_plan_commitment_payments_count, subsequent_installment_plan_commitment_payments_count
		]


## Represents details about a subscription offer.
##
## The SubscriptionOfferDetails class holds information about the
## subscription offer, including its base plan ID, pricing phases,
## and installment plan details.
class SubscriptionOfferDetails:
	
	var base_plan_id: String ## The unique identifier for the base plan.
	var installment_plan_details: InstallmentPlanDetails ## Details about the installment plan.
	var offer_id: String ## The unique identifier for the offer.
	var offer_tags: Array[String] ## Tags associated with the offer.
	var offer_token: String ## The token for the offer.
	var pricing_phase_list: Array[PricingPhase] ## List of pricing phases for the offer.
	
	
	## Initializes a new instance of SubscriptionOfferDetails.[br][br]
	##
	## [param base_plan_id] The unique identifier for the base plan.[br]
	## [param installment_plan_details] Details about the installment plan.[br]
	## [param offer_id] The unique identifier for the offer.[br]
	## [param offer_tags] Tags associated with the offer.[br]
	## [param offer_token ]The token for the offer.[br]
	## [param pricing_phase_list] List of pricing phases for the offer.[br]
	func _init(base_plan_id: String, installment_plan_details: InstallmentPlanDetails, 
		offer_id: String, offer_tags: Array[String], offer_token: String, 
		pricing_phase_list: Array[PricingPhase]):
		self.base_plan_id = base_plan_id
		self.installment_plan_details = installment_plan_details
		self.offer_id = offer_id
		self.offer_tags = offer_tags
		self.offer_token = offer_token
		self.pricing_phase_list = pricing_phase_list
	
	## Static method to create a SubscriptionOfferDetails instance from JSON data.[br][br]
	##
	## [param json_string] The JSON data as a string.[br][br]
	## Returns a new instance of SubscriptionOfferDetails created from the JSON data.[br]
	static func from_json(json_string: Variant) -> SubscriptionOfferDetails:
		#var data = JSON.parse_string(json_string)
		var data = json_string
		
		var installment_plan_details_string = data.get("installment_plan_details", null)
		var installment_plan_details: InstallmentPlanDetails = null
		if installment_plan_details_string != null:
			installment_plan_details = InstallmentPlanDetails.from_json(installment_plan_details_string)
		
		var pricing_phase_list_string = data.get("pricing_phase_list", null)
		var pricing_phase_list: Array[PricingPhase] = []
		if pricing_phase_list_string != null:
			pricing_phase_list = Utility.from_Json_to_PricingPhase_List(pricing_phase_list_string)
		
		var offer_tags = PackedStringArray()
		for tag in data.get("offer_tags", []):
			offer_tags.append(str(tag))
		
		return SubscriptionOfferDetails.new(
			data.get("base_plan_id", ""),
			installment_plan_details,
			data.get("offer_id", ""),
			offer_tags,
			data.get("offer_token", ""),
			pricing_phase_list
		)
	
	## Returns a string representation of the SubscriptionOfferDetails instance.
	func to_string() -> String:
		var details = "SubscriptionOfferDetails:\n"
		details += "  Base Plan ID: %s\n" % base_plan_id
		details += "  Installment Plan Details: %s\n" % (installment_plan_details.to_string() if installment_plan_details != null else "None")
		details += "  Offer ID: %s\n" % offer_id
		details += "  Offer Tags: %s\n" % offer_tags
		details += "  Offer Token: %s\n" % offer_token
		details += "  Pricing Phase List:\n"
		for pricing_phase in pricing_phase_list:
			details += "    - %s\n" % pricing_phase.to_string()
		return details
