local metadata =
{
	plugin =
	{
		format = 'staticLibrary',
		staticLibs = { 'plugin_googleAnalyticsV2','z','sqlite3'},
		frameworks = { "WebKit", "SafariServices", 'FirebaseAnalytics', 'FirebaseCore', 'FirebaseCoreDiagnostics', 'FirebaseInstallations', 'GoogleAppMeasurement','GoogleAppMeasurementIdentitySupport', 'GoogleDataTransport', 'GoogleUtilities', 'nanopb', 'PromisesObjC' },
		frameworksOptional = {},
	},
}

return metadata
