public with sharing class TweetController {
    
	// API KEYS
	private static final String API_KEY = 'xNZuf2Mna552FEI67tKVRotqR';
	private static final String SECRET_KEY = 'kzsxfPxktLJ3zARx2OxAjUViOHkrox6E67B1IsOkiCSsoru4Wh';
	private static final String API_KEY_ENCODED = EncodingUtil.urlEncode(API_KEY, 'UTF-8');
	private static final String SECRET_KEY_ENCODED = EncodingUtil.urlEncode(SECRET_KEY, 'UTF-8');

	private static final String twitterBaseURL = 'https://api.twitter.com/1.1/';
	private static final String twitterOAuthURL = 'https://api.twitter.com/oauth2/token';

	public static void generateAuthToken() {

		//Build Request
		HttpRequest req = new HttpRequest();
		req.setEndpoint(twitterOAuthURL);
		req.setMethod('POST');
		
		// generate authorization header
		String encodedApiKeys = API_KEY_ENCODED + ':' + SECRET_KEY_ENCODED;
		Blob headerValue = Blob.valueOf(encodedApiKeys);
		String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
		req.setHeader('Authorization', authorizationHeader);
		req.setBody('grant_type=client_credentials');
		
		Http http = new Http();

		HTTPResponse res = http.send(req);

		System.debug(res);
		System.debug(res.getBody());
		//Parse JSON for Bearer Token
		JSONParser parser = JSON.createParser(res.getBody());
		
		String authToken;
		while (parser.nextToken() != null) {
			if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'access_token'){
				parser.nextToken();
				authToken = parser.getText();
			}
		}

		// check privacy settings on this
		TwitterOAuthToken__c oAuth = new TwitterOAuthToken__c(Value__c=authToken);
		insert oAuth;
	}


	public static List<Tweet__c> getUserTimeline(String username) {
		return getUserTimeline(username, 500);
	}

	private static String getOAuthToken() {
		List<TwitterOAuthToken__c> tokens = [SELECT Value__c FROM TwitterOAuthToken__c LIMIT 1];

		if (tokens.size() == 0) {
			generateAuthToken();
			tokens = [SELECT Value__c FROM TwitterOAuthToken__c LIMIT 1];
		}

		return tokens[0].Value__c;
	}
	

	public static List<Tweet__c> getUserTimeline(String username, Integer count) {
		
		// build URL
		String calloutURL = twitterBaseURL + 'statuses/user_timeline.json';

		// specify user
		calloutURL += '?screen_name=' + username;

		// limit number of tweets returned
		calloutURL += '&count=' + count;
		
		// construct HTTP Request
		HTTPRequest req = new HTTPRequest();
		req.setMethod('GET');
		req.setEndpoint(calloutURL);
		
		// generate authorization header with AuthToken
		String authToken = getOAuthToken();
		
		String authHeader = 'Bearer ' + authToken;
		req.setHeader('Authorization', authHeader);
		
		HTTP http = new HTTP();
		HTTPResponse res = http.send(req);

		if (res.getStatusCode() == 200) {
			String apiResponse = res.getBody();
			System.debug(apiResponse);

			List<Object> responseList = (List<Object>) JSON.deserializeUntyped(apiResponse);
			for (Object tweet : responseList) {
				System.debug(tweet);
			}
		}

		return new List<Tweet__c>();
	}
}
