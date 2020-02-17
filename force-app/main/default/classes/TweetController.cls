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

	private static String getOAuthToken() {
		List<TwitterOAuthToken__c> tokens = [SELECT Value__c FROM TwitterOAuthToken__c LIMIT 1];

		if (tokens.size() == 0) {
			generateAuthToken();
			tokens = [SELECT Value__c FROM TwitterOAuthToken__c LIMIT 1];
		}

		return tokens[0].Value__c;
	}	

	public static List<Tweet__c> getUserTimeline(String username) {
		return getUserTimeline(username, 500);
	}

	public static List<Tweet__c> getUserTimeline(String username, Integer count) {
		List<Tweet__c> tweets = new List<Tweet__c>();
        
		// build URL
		String calloutURL = twitterBaseURL + 'statuses/user_timeline.json';

		// specify user
		calloutURL += '?screen_name=' + username;

		// limit number of tweets returned
		calloutURL += '&count=' + count;

		// add necessary params
		addAdditionalParameters(calloutURL);
		
		// construct HTTP Request
		HTTPRequest req = new HTTPRequest();
		req.setMethod('GET');
		req.setEndpoint(calloutURL);
		
		// generate authorization header with AuthToken
		String authToken = getOAuthToken();
		String authHeader = 'Bearer ' + authToken;
		req.setHeader('Authorization', authHeader);
		
		// send http request
		HTTP http = new HTTP();
		HTTPResponse res = http.send(req);

		if (res.getStatusCode() == 200) {
			String apiResponse = res.getBody();
			List<Object> responseTweets = (List<Object>) JSON.deserializeUntyped(apiResponse);
			
			for (Object tweet : responseTweets) {

				// parse result JSON
				Map<String, Object> jsonMap = (Map<String, Object>) tweet;
				Map<String, Object> author = (Map<String, Object>) jsonMap.get('user');
				
				// create new Tweet record
				Tweet__c t = new Tweet__c();
				t.Body__c = String.valueOf(jsonMap.get('full_text'));
				t.Author_Display_Name__c = String.valueOf(author.get('name'));
				t.Author_Username__c = String.valueOf(author.get('screen_name'));
				
				// parse timestamp
				String createdAt = String.valueOf(jsonMap.get('created_at'));
				List<String> dateComponents = createdAt.split(' ');
				String gmtString = dateComponents[5] + '-' + parseMonth(dateComponents[1]) + '-' + dateComponents[2] + ' ' + dateComponents[3];
				t.Timestamp__c = DateTime.valueOfGmt(gmtString);
				
				tweets.add(t);
			}
		}

		insert tweets;
		return tweets;
	}

	private static void addAdditionalParameters(String calloutURL) {
		calloutURL += '&include_rts=false&tweet_mode=extended';
	}
    
	private static string parseMonth(String abbreviation) {
		switch on abbreviation.toLowerCase() {
				when 'jan' {
					return '01';
				}
				when 'feb' {
					return '02';
				}
				when 'mar' {
					return '03';
				}
				when 'apr' {
					return '04';
				}
				when 'may' {
					return '05';
				}
				when 'jun' {
					return '06';
				}
				when 'jul' {
					return '07';
				}
				when 'aug' {
					return '08';
				}
				when 'sep' {
					return '09';
				}
				when 'oct' {
					return '10';
				}
				when 'nov' {
					return '11';
				}
				when 'dec' {
					return '12';
				}
		}
		return 'INVALID';
	}
}