# Bitget/Errors
# https://www.bitget.com/api-doc/spot/error-code/restapi

import ..CryptoExchangeAPIs: APIsResult, APIsUndefError
import ..CryptoExchangeAPIs: isretriable, retry_maxcount, retry_timeout

# UNDEF
isretriable(::APIsResult{BitgetAPIError}) = true
retry_timeout(e::APIsResult{BitgetAPIError}) = 1

# TOO_MANY_REQUESTS
isretriable(e::APIsResult{BitgetAPIError{429}}) = true
retry_timeout(e::APIsResult{BitgetAPIError{429}}) = 2
retry_maxcount(e::APIsResult{BitgetAPIError{429}}) = 50

# QUOTE_QUERY_FAILED
isretriable(e::APIsResult{BitgetAPIError{12004}}) = true
retry_timeout(e::APIsResult{BitgetAPIError{12004}}) = 1
retry_maxcount(e::APIsResult{BitgetAPIError{12004}}) = 5

# FAILED_TO_GET_QUOTE
isretriable(e::APIsResult{BitgetAPIError{12014}}) = true
retry_timeout(e::APIsResult{BitgetAPIError{12014}}) = 1
retry_maxcount(e::APIsResult{BitgetAPIError{12014}}) = 5

# SERVICE_DISRUPTION
isretriable(e::APIsResult{BitgetAPIError{12018}}) = true
retry_timeout(e::APIsResult{BitgetAPIError{12018}}) = 10
retry_maxcount(e::APIsResult{BitgetAPIError{12018}}) = 2
