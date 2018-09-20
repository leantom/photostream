/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Quotes {
	public var quote : String?
	public var length : String?
	public var author : String?
	public var tags : Array<String>?
	public var category : String?
	public var date : String?
	public var permalink : String?
	public var title : String?
	public var background : String?
	public var id : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let quotes_list = Quotes.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Quotes Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Quotes]
    {
        var models:[Quotes] = []
        for item in array
        {
            models.append(Quotes(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let quotes = Quotes(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Quotes Instance.
*/
	required public init?(dictionary: NSDictionary) {

		quote = dictionary["quote"] as? String
		length = dictionary["length"] as? String
		author = dictionary["author"] as? String
        if (dictionary["tags"] != nil) { tags = (dictionary["tags"] as! NSArray as! Array<String>) }
		category = dictionary["category"] as? String
		date = dictionary["date"] as? String
		permalink = dictionary["permalink"] as? String
		title = dictionary["title"] as? String
		background = dictionary["background"] as? String
		id = dictionary["id"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.quote, forKey: "quote")
		dictionary.setValue(self.length, forKey: "length")
		dictionary.setValue(self.author, forKey: "author")
		dictionary.setValue(self.category, forKey: "category")
		dictionary.setValue(self.date, forKey: "date")
		dictionary.setValue(self.permalink, forKey: "permalink")
		dictionary.setValue(self.title, forKey: "title")
		dictionary.setValue(self.background, forKey: "background")
		dictionary.setValue(self.id, forKey: "id")

		return dictionary
	}

}
