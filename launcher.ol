from runtime import Runtime
from file import File
from console import Console
from string_utils import StringUtils

service Launcher {
	embed Runtime as runtime
	embed File as file
	embed Console as Console
	embed StringUtils as StringUtils

	main {
		if ( is_defined( args[0] ) ) {
			dir = args[0]
		} else {
			getenv@runtime( "LEONARDO_WWW" )( dir )
		}

		// Ensure that the path ends with a slash (/)
		e = dir
		e.suffix = "/"
		endsWith@StringUtils( e )( ends_with_slash )

		if(! ends_with_slash) {
			dir += "/"
		}

		exists@file( dir )( root_dir_exists )
		if( root_dir_exists ) {
			config.template = dir + "template/"
			config.data = dir + "data/"
			config.outputPath = dir

			exists@file( dir + "data/global.json" )( global_data_exists )
			if( global_data_exists ) {
				config.globalData = dir + "data/global.json"
			}
		}

		getRealServiceDirectory@file()( home )
		getFileSeparator@file()( sep )

		loadEmbeddedService@runtime( {
			filepath = home + sep + "main.ol"
			service = "FreemarkerService"
			params -> config
		} )()

		linkIn( Shutdown )
	}
}