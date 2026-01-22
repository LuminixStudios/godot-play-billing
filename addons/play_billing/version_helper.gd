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


## Provides helper functions related to version management.
## 
## The VersionHelper class contains utility methods to retrieve
## version details of the Godot Play Billing plugin by reading from
## the plugin configuration file.
class_name VersionHelper


## Retrieves the version number of the Play Billing plugin.[br]
##
## This method reads the version from the `plugin.cfg` file located
## in the `addons/play_billing` directory. If the file cannot be loaded,
## it logs an error message.[br][br]
##
## Returns the plugin version as a [String]. If the file fails to load, an empty string is returned.[br]
static func get_plugin_version() -> String:
	var plugin_config_file := ConfigFile.new()
	var version: String = ""
	
	if plugin_config_file.load("res://addons/play_billing/plugin.cfg") == OK:
		version = plugin_config_file.get_value("plugin", "version")
	else:
		push_error("Failed to load plugin.cfg")
	
	return version
