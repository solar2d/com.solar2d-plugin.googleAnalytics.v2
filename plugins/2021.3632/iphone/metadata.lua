local metadata =
{
	plugin =
	{
		format = 'staticLibrary',
		staticLibs = { 'plugin_googleAnalyticsV2','z','sqlite3'},
		frameworks = { "WebKit", "SafariServices", 'FBLPromises', 'FirebaseAnalytics',"FirebaseAnalyticsSwift", 'FirebaseCore', 'FirebaseCoreInternal', 'FirebaseInstallations', 'GoogleAppMeasurement','GoogleAppMeasurementIdentitySupport', 'GoogleUtilities', 'nanopb' },
		frameworksOptional = {},
		usesSwift =true,
	},
}

return metadata
