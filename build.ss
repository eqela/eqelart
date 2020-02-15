#! eqela sling-r106
#
# This file is part of Eqela Runtime
# Copyright (c) 2018-2020 Eqela Oy
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 3 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#

lib scf:r106
lib sling:r106
lib jkop:20200215
import jk.lang
import jk.fs
import sling.build

Context.execute(func {
	var version = args[0]
	if String.isEmpty(version) {
		Context.info("Usage: build.ss <version>")
		return
	}
	var outputdir = "build/eqelart-release-" .. version
	var appoutput = outputdir .. "/eqelart-" .. version
	var appoutput_ubuntu1804 = appoutput .. "_ubuntu1804"
	var appoutput_macos = appoutput .. "_macos"
	var appoutput_win32 = appoutput .. "_win32"
	var workdir = "build/workdir_" .. version
	Compiler.compileApp({
		"source" : "src/eqela",
		"output" : appoutput_ubuntu1804,
		"workdir" : workdir,
		"version" : version,
		"wrapvm" : true,
		"vm" : "sushi/sushi-20200209-ubuntu1804"
	})
	Compiler.compileApp({
		"source" : "src/eqela",
		"output" : appoutput_macos,
		"workdir" : workdir,
		"version" : version,
		"wrapvm" : true,
		"vm" : "sushi/sushi-20200209-macos"
	})
	Compiler.compileApp({
		"source" : "src/eqela",
		"output" : appoutput_win32,
		"workdir" : workdir,
		"version" : version,
		"wrapvm" : true,
		"vm" : "sushi/sushi-20200209-win32.exe"
	})
	Context.print(Zip.compress(appoutput_ubuntu1804))
	Context.print(Zip.compress(appoutput_macos))
	Context.print(Zip.compress(appoutput_win32))
	File.forPath(appoutput_ubuntu1804).removeRecursive()
	File.forPath(appoutput_macos).removeRecursive()
	File.forPath(appoutput_win32).removeRecursive()
})
