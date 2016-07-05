//
//  php-extensions.swift
//  swift-php-extensions
//
//  Created by Michael Richter on 05.07.16.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

// -------------------------------------------------------
// MARK: - php-like alias functions
// -------------------------------------------------------

@warn_unused_result
public func empty(object:AnyObject?=nil) -> Bool{
    if object == nil {
        return true
    }
    if let bool = object as? Bool {
        return !bool
    }
    if let n = object as? Int {
        return n == 0
    }
    if let n = object as? Double {
        return n == 0.0
    }
    if let str = object as? String {
        return str == "" || str=="0"
    }
    if let arr = object as? Array<AnyObject> {
        return arr.count==0
    }
    
    return true
}

@warn_unused_result
public func in_array(needle:AnyObject,haystack: NSArray) -> Bool{
    return haystack.containsObject(needle)
}

/** Removes html-tags _(<...>)_ from given string
 */
@warn_unused_result
public func strip_tags(str:String) -> String {
    return str.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
}


/** Format date object with given format string
 - Parameters:
 - format: A string with format conforming to default NSFormatter syntax
 - date: **Optional**: NSDate object to use formatter on, default is current date
 - locale: **Optional**: Locale identifier string to use for formatting, default is "de_DE"
 
 - Returns: Formatted date as String
 */
@warn_unused_result
public func date(format:String, date:NSDate=NSDate(), locale:String="de_DE") -> String{
    let df = NSDateFormatter()
    df.locale = NSLocale(localeIdentifier: locale)
    df.dateFormat = format
    return df.stringFromDate(date)
}
@warn_unused_result
public func date_format(format:String, date sourceDate:NSDate=NSDate(), locale:String="de_DE") -> String {
    return date(format, date: sourceDate, locale: locale)
}


@warn_unused_result
public func number_format(num:NSNumber,_ decimals:Int=0,_ lang:String="de") -> String{
    let nf = NSNumberFormatter()
    nf.locale = NSLocale(localeIdentifier: lang)
    nf.numberStyle = NSNumberFormatterStyle.DecimalStyle
    nf.minimumFractionDigits = decimals
    nf.maximumFractionDigits = decimals
    return nf.stringFromNumber(num)!
}

/** Replaces all occurrencies of needle in given hackstack with new string
 - Paramaters:
 - search: String or Array of Strings to be replaced
 - replace: replacement string
 - subject: string to be searched for replacement
 */
@warn_unused_result
public func str_replace<Obj>(search:Obj,_ replace:String,_ subject:String) -> String {
    if search is String {
        return subject.stringByReplacingOccurrencesOfString(search as! String, withString: replace)
    } else if search is [String] {
        var str = subject
        for el in search as! [String] {
            str = str.stringByReplacingOccurrencesOfString(el, withString: replace)
        }
        return str
    }
    
    return subject
}


/** Creates a http query string from given dictionary, accepted types for AnyObject are _String, Array, Dictionary_.
 
 Arrays are translated to keyname[RUN]=value
 
 Dictionaries are translated to keyname[valuesName]=valuesValue
 */
@warn_unused_result
public func http_build_query(dict:[String:AnyObject]) -> String {
    var arr = [String]()
    for (key,value) in dict {
        if value.isKindOfClass(NSDictionary.classForCoder()) {
            for(k,v) in value as! NSDictionary {
                arr.append(key + "[\(k)]=" + (v as! String) as String ?? "")
            }
            
        } else if value.isKindOfClass(NSArray.classForCoder()) {
            //            for var i=0; i < (value as! NSArray).count; i++ {
            for i in 0 ..< (value as! NSArray).count {
                arr.append(key + "[\(i)]=" + ((value as! NSArray)[i] as! String) as String ?? "")
            }
            
        } else if value.isKindOfClass(NSString.classForCoder()) {
            arr.append(key + "=" + (value as! String) as String ?? "")
        }
    }
    
    return arr.joinWithSeparator("&")
}

/** Builds a valid url string from given string by replacing illegal special characters with percent escapes
 */
@warn_unused_result
public func urlencode(str:String) -> String {
    let charset         = "!*'();:@&=+$,/?%#[]"
    let escapedString = CFURLCreateStringByAddingPercentEscapes(
        nil,
        str,
        nil,
        charset,
        CFStringBuiltInEncodings.UTF8.rawValue
    )
    return escapedString as String
}

/** Check if file(name) exists in given directory, default dir is 'Documents'
 */
@warn_unused_result
public func file_exists(file:String, dir:String=UIApplication.documentDirectory) -> Bool{
    let filepath = dir + file
    return NSFileManager.defaultManager().fileExistsAtPath( filepath )
}