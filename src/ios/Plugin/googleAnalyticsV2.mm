//
//  googleAnalytics.mm
//  Google Analytics v2 Plugin
//
//  Copyright (c) 2021 Solar2d All rights reserved.
//

#import "googleAnalyticsV2.h"

#include <CoronaRuntime.h>
#import <UIKit/UIKit.h>
#import <FirebaseAnalytics/FirebaseAnalytics.h>
#import <FirebaseCore/FirebaseCore.h>
#import <CoronaLuaIOS.h>
// ----------------------------------------------------------------------------

class googleAnalytics
{
	public:
		typedef googleAnalytics Self;

	public:
		static const char kName[];
		static const char kEvent[];

	protected:
        googleAnalytics();

	public:
		bool Initialize( CoronaLuaRef listener );

	public:
		CoronaLuaRef GetListener() const { return fListener; }

	public:
		static int Open( lua_State *L );

	protected:
		static int Finalizer( lua_State *L );

	public:
		static Self *ToLibrary( lua_State *L );

	public:
		static int init( lua_State *L );
		static int logEvent( lua_State *L );
        static int logScreenName( lua_State *L );

	private:
		CoronaLuaRef fListener;
};

// ----------------------------------------------------------------------------
static NSString *
ToNSString( lua_State *L, int index )
{
    NSString *result = nil;
    
    int t = lua_type( L, -2 );
    switch ( t )
    {
        case LUA_TNUMBER:
            result = [NSString stringWithFormat:@"%g", lua_tonumber( L, index )];
            break;
        default:
            result = [NSString stringWithUTF8String:lua_tostring( L, index )];
            break;
    }
    
    return result;
}

const char googleAnalytics::kName[] = "plugin.googleAnalytics.v2";

const char googleAnalytics::kEvent[] = "plugingoogleanalyticv2sevent";

googleAnalytics::googleAnalytics()
:	fListener( NULL )
{
}

bool
googleAnalytics::Initialize( CoronaLuaRef listener )
{
	// Can only initialize listener once
	bool result = ( NULL == fListener );

	if ( result )
	{
		fListener = listener;
	}

	return result;
}

int
googleAnalytics::Open( lua_State *L )
{
	// Register __gc callback
	const char kMetatableName[] = __FILE__; // Globally unique string to prevent collision
	CoronaLuaInitializeGCMetatable( L, kMetatableName, Finalizer );

	// Functions in library
	const luaL_Reg kVTable[] =
	{
		{ "init", init },
		{ "logEvent", logEvent },
        { "logScreenName", logScreenName },
        
		{ NULL, NULL }
	};

	// Set library as upvalue for each library function
	Self *library = new Self;
	CoronaLuaPushUserdata( L, library, kMetatableName );

	luaL_openlib( L, kName, kVTable, 1 ); // leave "library" on top of stack

	return 1;
}

int
googleAnalytics::Finalizer( lua_State *L )
{
	Self *library = (Self *)CoronaLuaToUserdata( L, 1 );

	CoronaLuaDeleteRef( L, library->GetListener() );

	delete library;

	return 0;
}

googleAnalytics *
googleAnalytics::ToLibrary( lua_State *L )
{
	// library is pushed as part of the closure
	Self *library = (Self *)CoronaLuaToUserdata( L, lua_upvalueindex( 1 ) );
	return library;
}

int
googleAnalytics::init( lua_State *L )
{
    [FIRApp configure];
	return 0;
}

int
googleAnalytics::logEvent( lua_State *L )
{
    if (lua_isstring(L, 2) == true) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{
            @"action":ToNSString(L, 2)
        }];
        if (lua_isstring(L, 3) == true) {
            [params setObject:ToNSString(L, 3) forKey:@"label"];
        }
        if (lua_isnumber(L, 3) == true) {
            [params setObject:[NSNumber numberWithDouble:lua_tonumber(L,3)] forKey:@"value"];
        }
        if (lua_isnumber(L, 4) == true) {
            [params setObject:[NSNumber numberWithDouble:lua_tonumber(L,4)] forKey:@"value"];
        }
        
        
        [FIRAnalytics logEventWithName:ToNSString(L, 1)
                            parameters:params];
    }else{
        [FIRAnalytics logEventWithName:ToNSString(L, 1)
                            parameters:CoronaLuaCreateDictionary(L, 2)];
    }
   
    return 0;
}
int
googleAnalytics::logScreenName( lua_State *L )
{
    [FIRAnalytics logEventWithName:kFIREventScreenView
                        parameters:@{
                                     kFIRParameterScreenName: ToNSString(L, 1)}];
    return 0;
}

// ----------------------------------------------------------------------------

CORONA_EXPORT int luaopen_plugin_googleAnalytics_v2( lua_State *L )
{
	return googleAnalytics::Open( L );
}
