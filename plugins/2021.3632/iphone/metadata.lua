local metadata =
{
	plugin =
	{
		format = 'staticLibrary',
		staticLibs = { 'plugin_googleAnalyticsV2','z','sqlite3'},
		frameworks = { 'FirebaseAnalytics', 'GoogleAppMeasurement', 'UserMessagingPlatform', 'FBLPromises', 'FirebaseABTesting', 'FirebaseCore', 'FirebaseCoreDiagnostics', 'FirebaseInstallations', 'FirebaseMessaging', 'FirebaseRemoteConfig', 'GoogleDataTransport', 'GoogleUtilities', 'nanopb', },
		frameworksOptional = {},
	},
}

return metadata
