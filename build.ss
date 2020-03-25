#! eqela sling-r118
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

lib sling:r118
import jk.lang
import jk.fs
import jk.script
import sling.compiler
import jk.util.archive
import jk.util.download

var sushiVersion = "v1.0.1"

var script = new Script()
var compiler = new SlingCompilerKit(script.ctx)
var archive = new ArchiveKit(script.ctx)
var file = new FileKit(script.ctx)
var download = new DownloadKit(script.ctx)

script.command("release", func(args) {
	var version = script.requireParameter(args, 0, "version")
	download.downloadAndExtract("https://github.com/eqela/sushivm/releases/download/" .. sushiVersion .. "/sushi_" .. sushiVersion .. "_linux.zip", "build/sushi_linux_" .. sushiVersion)
	download.downloadAndExtract("https://github.com/eqela/sushivm/releases/download/" .. sushiVersion .. "/sushi_" .. sushiVersion .. "_macos.zip", "build/sushi_macos_" .. sushiVersion)
	download.downloadAndExtract("https://github.com/eqela/sushivm/releases/download/" .. sushiVersion .. "/sushi_" .. sushiVersion .. "_win32.zip", "build/sushi_win32_" .. sushiVersion)
	var outputdir = "build/eqelart-release-" .. version
	var appoutput = outputdir .. "/eqelart-" .. version
	var appoutput_linux = appoutput .. "_linux"
	var appoutput_macos = appoutput .. "_macos"
	var appoutput_win32 = appoutput .. "_win32"
	var workdir = "build/workdir_" .. version
	compiler.compileApp({
		"source" : "src/eqela",
		"output" : appoutput_linux,
		"workdir" : workdir,
		"version" : version,
		"wrapvm" : true,
		"vm" : "build/sushi_linux_" .. sushiVersion .. "/sushi"
	})
	compiler.compileApp({
		"source" : "src/eqela",
		"output" : appoutput_macos,
		"workdir" : workdir,
		"version" : version,
		"wrapvm" : true,
		"vm" : "build/sushi_macos_" .. sushiVersion .. "/sushi"
	})
	compiler.compileApp({
		"source" : "src/eqela",
		"output" : appoutput_win32,
		"workdir" : workdir,
		"version" : version,
		"wrapvm" : true,
		"vm" : "build/sushi_win32_" .. sushiVersion .. "/sushi.exe"
	})
	file.copy("LICENSE", appoutput_linux)
	file.copy("LICENSE", appoutput_macos)
	file.copy("LICENSE", appoutput_win32)
	script.print(archive.compressZip(appoutput_linux))
	script.print(archive.compressZip(appoutput_macos))
	script.print(archive.compressZip(appoutput_win32))
	file.remove(appoutput_linux)
	file.remove(appoutput_macos)
	file.remove(appoutput_win32)
})

script.command("clean", func(args) {
	file.remove("build")
})

script.main(args)
