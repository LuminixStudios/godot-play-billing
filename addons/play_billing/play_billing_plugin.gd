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


## This is the main plugin class for integrating Google Play Billing into Godot.
##
## It extends the EditorPlugin class and provides functionality for exporting
## the PlayBilling plugin on the Android platform.
@tool
class_name PlayBillingPlugin extends EditorPlugin


var _export_plugin: PlayBillingExportPlugin

## Stores the version of the PlayBilling plugin retrieved from VersionHelper
var plugin_version: String = VersionHelper.get_plugin_version()


class PlayBillingExportPlugin extends EditorExportPlugin:
	
	func _get_name() -> String:
		return "PlayBilling"
	
	
	func _supports_platform(platform: EditorExportPlatform) -> bool:
		if platform is EditorExportPlatformAndroid:
			return true
		return false
	
	
	func _get_android_libraries(
		platform: EditorExportPlatform, debug: bool
	) -> PackedStringArray:
		if debug:
			return PackedStringArray(
				["res://addons/play_billing/aar/GodotPlayBilling-debug.aar"]
			)
		return PackedStringArray(
			["res://addons/play_billing/aar/GodotPlayBilling-release.aar"]
		)
	
	func _get_android_dependencies(
		platform: EditorExportPlatform, debug: bool) -> PackedStringArray:
		return PackedStringArray(
			["com.android.billingclient:billing-ktx:8.3.0"]
		)


func _enter_tree() -> void:
	_export_plugin = PlayBillingExportPlugin.new()
	add_export_plugin(_export_plugin)


func _exit_tree() -> void:
	remove_export_plugin(_export_plugin)
	_export_plugin = null
