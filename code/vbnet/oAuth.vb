Imports System
Imports System.Security.Cryptography
Imports System.Collections
Imports System.Collections.Generic
Imports System.Text
Imports System.Web

Namespace OAuth
    Public Class OAuthBase
        ''
        ' List of know and used oauth parameters' names
        ''        
        Protected Const OAuthVersion As String = "1.0"
        Protected Const OAuthParameterPrefix As String = "oauth_"
        Protected Const OAuthConsumerKeyKey As String = "oauth_consumer_key"
        Protected Const OAuthCallbackKey As String = "oauth_callback"
        Protected Const OAuthVersionKey As String = "oauth_version"
        Protected Const OAuthSignatureMethodKey As String = "oauth_signature_method"
        Protected Const OAuthSignatureKey As String = "oauth_signature"
        Protected Const OAuthTimestampKey As String = "oauth_timestamp"
        Protected Const OAuthNonceKey As String = "oauth_nonce"
        Protected Const OAuthTokenKey As String = "oauth_token"
        Protected Const OAuthTokenSecretKey As String = "oauth_token_secret"
        Protected Const HMACSHA1SignatureType As String = "HMAC-SHA1"
        Protected Const PlainTextSignatureType As String = "PLAINTEXT"
        Protected Const RSASHA1SignatureType As String = "RSA-SHA1"
        Protected random As New Random()
        Protected unreservedChars As String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.~"

        ''' <summary>
        ''' Provides a predefined set of algorithms that are supported officially by the protocol
        ''' </summary>
        Public Enum SignatureTypes
            HMACSHA1
            PLAINTEXT
            RSASHA1
        End Enum

        ''' <summary>
        ''' Provides an internal structure to sort the query parameter
        ''' </summary>
        Protected Class QueryParameter
            Private name As String = Nothing
            Private value As String = Nothing
            Public Sub New(ByVal Name As String, ByVal value As String)
                Me.name = Name
                Me.value = value
            End Sub
            Public ReadOnly Property Nome() As String
                Get
                    Return name
                End Get
            End Property
            Public ReadOnly Property Valor() As String
                Get
                    Return value
                End Get
            End Property
        End Class

        ''' <summary>
        ''' Comparer class used to perform the sorting of the query parameters
        ''' </summary>
        Protected Class QueryParameterComparer
#Region "IComparer<QueryParameter> Members"
            Public Function Compare(ByVal x As QueryParameter, ByVal y As QueryParameter) As Integer
                If (x.Nome = y.Nome) Then
                    Return String.Compare(x.Valor, y.Valor)
                Else
                    Return String.Compare(x.Nome, y.Nome)
                End If
            End Function
#End Region
        End Class

        ''' <summary>
        ''' Helper function to compute a hash value
        ''' </summary>
        ''' <param name="hashAlgorithm">The hashing algoirhtm used. If that algorithm needs some initialization, like HMAC and its derivatives, they should be initialized prior to passing it to this function</param>
        ''' <param name="data">The data to hash</param>
        ''' <returns>a Base64 string of the hash value</returns>
        Private Function ComputeHash(ByVal hashAlgorithm As HashAlgorithm, ByVal data As String) As String
            If (hashAlgorithm Is Nothing) Then
                Throw New ArgumentNullException("hashAlgorithm")
            End If

            If (String.IsNullOrEmpty(data)) Then
                Throw New ArgumentNullException("data")
            End If

            Dim dataBuffer As Byte() = System.Text.Encoding.ASCII.GetBytes(data)
            Dim hashBytes As Byte() = hashAlgorithm.ComputeHash(dataBuffer)
            Return Convert.ToBase64String(hashBytes)
        End Function

        ''' <summary>
        ''' Internal function to cut out all non oauth query string parameters (all parameters not begining with "oauth_")
        ''' </summary>
        ''' <param name="parameters">The query string part of the Url</param>
        ''' <returns>A list of QueryParameter each containing the parameter name and value</returns>
        Private Function GetQueryParameters(ByVal parameters As String) As List(Of QueryParameter)
            If (parameters.StartsWith("?")) Then
                parameters = parameters.Remove(0, 1)
            End If
            Dim result As New List(Of QueryParameter)
            If (Not String.IsNullOrEmpty(parameters)) Then
                Dim p As String() = parameters.Split("&")
                For Each s As String In p
                    If (Not String.IsNullOrEmpty(s) And Not s.StartsWith(OAuthParameterPrefix)) Then
                        If (s.IndexOf("=") > -1) Then
                            Dim temp As String() = s.Split("=")
                            result.Add(New QueryParameter(temp(0), temp(1)))
                        Else
                            result.Add(New QueryParameter(s, String.Empty))
                        End If
                    End If
                Next
            End If
            Return result
        End Function

        ''' <summary>
        ''' This is a different Url Encode implementation since the default .NET one outputs the percent encoding in lower case.
        ''' While this is not a problem with the percent encoding spec, it is used in upper case throughout OAuth
        ''' </summary>
        ''' <param name="value">The value to Url encode</param>
        ''' <returns>Returns a Url encoded string</returns>
        Protected Function UrlEncode(ByVal value As String) As String
            Dim result As New StringBuilder()
            For Each symbol As Char In value
                If unreservedChars.IndexOf(symbol) <> -1 Then
                    result.Append(symbol)
                Else
                    result.Append("%" + String.Format("{0:X2}", Convert.ToInt32(symbol)))
                End If
            Next
            Return result.ToString()
        End Function

        ''' <summary>
        ''' Normalizes the request parameters according to the spec
        ''' </summary>
        ''' <param name="parameters">The list of parameters already sorted</param>
        ''' <returns>a string representing the normalized parameters</returns>
        Protected Function NormalizeRequestParameters(ByVal parameters As IList(Of QueryParameter)) As String
            Dim sb As New StringBuilder()
            Dim i As Integer
            Dim p As QueryParameter = Nothing

            For i = 0 To parameters.Count - 1
                p = parameters(i)
                sb.AppendFormat("{0}={1}", p.Nome, p.Valor)

                If (i < parameters.Count - 1) Then
                    sb.Append("&")
                End If
            Next

            Return sb.ToString()
        End Function

        ''' <summary>
        ''' Generate the signature base that is used to produce the signature
        ''' </summary>
        ''' <param name="url">The full url that needs to be signed including its non OAuth url parameters</param>
        ''' <param name="consumerKey">The consumer key</param>        
        ''' <param name="token">The token, if available. If not available pass null or an empty string</param>
        ''' <param name="tokenSecret">The token secret, if available. If not available pass null or an empty string</param>
        ''' <param name="httpMethod">The http method used. Must be a valid HTTP method verb (POST,GET,PUT, etc)</param>
        ''' <param name="signatureType">The signature type. To use the default values use <see cref="OAuthBase.SignatureTypes">OAuthBase.SignatureTypes</see>.</param>
        ''' <returns>The signature base</returns>
        Public Function GenerateSignatureBase(ByVal url As Uri, ByVal consumerKey As String, ByVal token As String, ByVal tokenSecret As String, ByVal httpMethod As String, ByVal timeStamp As String, ByVal nonce As String, ByVal signatureType As String, ByRef normalizedUrl As String, ByRef normalizedRequestParameters As String) As String
            If token Is Nothing Then
                token = String.Empty
            End If
            If tokenSecret Is Nothing Then
                tokenSecret = String.Empty
            End If
            If String.IsNullOrEmpty(consumerKey) Then
                Throw New ArgumentException("consumerKey")
            End If
            If String.IsNullOrEmpty(httpMethod) Then
                Throw New ArgumentNullException("httpMethod")
            End If
            If String.IsNullOrEmpty(signatureType) Then
                Throw New ArgumentNullException("signatureType")
            End If
            normalizedUrl = Nothing
            normalizedRequestParameters = Nothing

            Dim parameters As List(Of QueryParameter) = GetQueryParameters(url.Query)
            parameters.Add(New QueryParameter(OAuthVersionKey, OAuthVersion))
            parameters.Add(New QueryParameter(OAuthNonceKey, nonce))
            parameters.Add(New QueryParameter(OAuthTimestampKey, timeStamp))
            parameters.Add(New QueryParameter(OAuthSignatureMethodKey, signatureType))
            parameters.Add(New QueryParameter(OAuthConsumerKeyKey, consumerKey))

            If (Not String.IsNullOrEmpty(token)) Then
                parameters.Add(New QueryParameter(OAuthTokenKey, token))
            End If
            'parameters.Sort(New QueryParameterComparer())
            normalizedUrl = String.Format("{0}://{1}", url.Scheme, url.Host)

            If (Not ((url.Scheme = "http" And url.Port = 80) Or (url.Scheme = "https" And url.Port = 443))) Then
                normalizedUrl += ":" + url.Port
            End If

            normalizedUrl += url.AbsolutePath
            normalizedRequestParameters = NormalizeRequestParameters(parameters)

            Dim signatureBase As New StringBuilder()
            signatureBase.AppendFormat("{0}&", httpMethod.ToUpper())
            signatureBase.AppendFormat("{0}&", UrlEncode(normalizedUrl))
            signatureBase.AppendFormat("{0}", UrlEncode(normalizedRequestParameters))
            Return signatureBase.ToString()
        End Function

        ''' <summary>
        ''' Generate the signature value based on the given signature base and hash algorithm
        ''' </summary>
        ''' <param name="signatureBase">The signature based as produced by the GenerateSignatureBase method or by any other means</param>
        ''' <param name="hash">The hash algorithm used to perform the hashing. If the hashing algorithm requires initialization or a key it should be set prior to calling this method</param>
        ''' <returns>A base64 string of the hash value</returns>
        Public Function GenerateSignatureUsingHash(ByVal signatureBase As String, ByVal hash As HashAlgorithm) As String
            Return ComputeHash(hash, signatureBase)
        End Function

        ''' <summary>
        ''' Generates a signature using the HMAC-SHA1 algorithm
        ''' </summary>		
        ''' <param name="url">The full url that needs to be signed including its non OAuth url parameters</param>
        ''' <param name="consumerKey">The consumer key</param>
        ''' <param name="consumerSecret">The consumer seceret</param>
        ''' <param name="token">The token, if available. If not available pass null or an empty string</param>
        ''' <param name="tokenSecret">The token secret, if available. If not available pass null or an empty string</param>
        ''' <param name="httpMethod">The http method used. Must be a valid HTTP method verb (POST,GET,PUT, etc)</param>
        ''' <returns>A base64 string of the hash value</returns>
        Public Function GenerateSignature(ByVal url As Uri, ByVal consumerKey As String, ByVal consumerSecret As String, ByVal token As String, ByVal tokenSecret As String, ByVal httpMethod As String, ByVal timeStamp As String, ByVal nonce As String, ByRef normalizedUrl As String, ByRef normalizedRequestParameters As String) As String
            Return GenerateSignature(url, consumerKey, consumerSecret, token, tokenSecret, httpMethod, timeStamp, nonce, SignatureTypes.HMACSHA1, normalizedUrl, normalizedRequestParameters)
        End Function

        ''' <summary>
        ''' Generates a signature using the specified signatureType 
        ''' </summary>		
        ''' <param name="url">The full url that needs to be signed including its non OAuth url parameters</param>
        ''' <param name="consumerKey">The consumer key</param>
        ''' <param name="consumerSecret">The consumer seceret</param>
        ''' <param name="token">The token, if available. If not available pass null or an empty string</param>
        ''' <param name="tokenSecret">The token secret, if available. If not available pass null or an empty string</param>
        ''' <param name="httpMethod">The http method used. Must be a valid HTTP method verb (POST,GET,PUT, etc)</param>
        ''' <param name="signatureType">The type of signature to use</param>
        ''' <returns>A base64 string of the hash value</returns>
        Public Function GenerateSignature(ByVal url As Uri, ByVal consumerKey As String, ByVal consumerSecret As String, ByVal token As String, ByVal tokenSecret As String, ByVal httpMethod As String, ByVal timeStamp As String, ByVal nonce As String, ByVal signatureType As SignatureTypes, ByRef normalizedUrl As String, ByRef normalizedRequestParameters As String) As String
            normalizedUrl = Nothing
            normalizedRequestParameters = Nothing
            Select Case signatureType
                Case SignatureTypes.HMACSHA1
                    Dim signatureBase As String = GenerateSignatureBase(url, consumerKey, token, tokenSecret, httpMethod, timeStamp, nonce, HMACSHA1SignatureType, normalizedUrl, normalizedRequestParameters)
                    Dim hmacsha1 As New HMACSHA1()
                    hmacsha1.Key = Encoding.ASCII.GetBytes(String.Format("{0}&{1}", UrlEncode(consumerSecret), IIf(String.IsNullOrEmpty(tokenSecret), "", UrlEncode(tokenSecret))))
                    Return GenerateSignatureUsingHash(signatureBase, hmacsha1)
                Case SignatureTypes.PLAINTEXT
                    Return UrlEncode(String.Format("{0}&{1}", consumerSecret, tokenSecret))
                Case SignatureTypes.RSASHA1
                    Throw New NotImplementedException()
                Case Else
                    Throw New ArgumentException("Unknown signature type", "signatureType")
            End Select
        End Function

        ''' <summary>
        ''' Generate the timestamp for the signature        
        ''' </summary>
        ''' <returns></returns>
        Public Function GenerateTimeStamp() As String
            ' Default implementation of UNIX time of the current UTC time
            Dim ts As TimeSpan = DateTime.UtcNow - New DateTime(1970, 1, 1, 0, 0, 0, 0)
            Return Convert.ToInt64(ts.TotalSeconds).ToString()
        End Function

        ''' <summary>
        ''' Generate a nonce
        ''' </summary>
        ''' <returns></returns>
        Public Function GenerateNonce() As String
            ' Just a simple implementation of a random number between 123400 and 9999999
            Return random.Next(123400, 9999999).ToString()
        End Function
    End Class
    
End Namespace