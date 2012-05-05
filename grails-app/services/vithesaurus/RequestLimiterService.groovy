package vithesaurus

import com.vionto.vithesaurus.ThesaurusConfigurationEntry
import com.vionto.vithesaurus.ApiRequestEvent
import com.vionto.vithesaurus.tools.IpTools

class RequestLimiterService {

  static transactional = false

  private static final int API_REQUEST_QUEUE_SIZE = 500
  private static final String REQUEST_LIMIT_MAX_AGE_SECONDS = "requestLimitMaxAgeSeconds"
  private static final String REQUEST_LIMIT_MAX_REQUESTS = "requestLimitMaxRequests"
  private static final String REQUEST_LIMIT_SLEEP_TIME_MILLIS = "requestLimitSleepTimeMillis"
  private static final String REQUEST_LIMIT_IPS = "requestLimitIps"
  private static final String REQUEST_LIMIT_SPECIAL_IPS_PREFIX = "requestLimitForIp"

  private apiRequestEvents = []

  /**
   * Throw exception if user makes too many requests
   * @return logging string
   */
  String preventRequestFlooding(def request) {
    while (apiRequestEvents.size() > API_REQUEST_QUEUE_SIZE) {
      apiRequestEvents.remove(0)
    }
    String ip = IpTools.getRealIpAddress(request)
    apiRequestEvents.add(new ApiRequestEvent(ip, new Date()))

    int maxAgeSeconds = 60
    ThesaurusConfigurationEntry maxAgeSecondsObj = ThesaurusConfigurationEntry.findByKey(REQUEST_LIMIT_MAX_AGE_SECONDS)
    if (maxAgeSecondsObj != null) {
      maxAgeSeconds = Integer.parseInt(maxAgeSecondsObj.value)
    }

    int maxRequests = 5
    ThesaurusConfigurationEntry maxRequestsObj = ThesaurusConfigurationEntry.findByKey(REQUEST_LIMIT_MAX_REQUESTS)
    if (maxRequestsObj != null) {
      maxRequests = Integer.parseInt(maxRequestsObj.value)
    }

    long sleepTime = 5000
    ThesaurusConfigurationEntry sleepTimeObj = ThesaurusConfigurationEntry.findByKey(REQUEST_LIMIT_SLEEP_TIME_MILLIS)
    if (sleepTimeObj != null) {
      sleepTime = Long.parseLong(sleepTimeObj.value)
    }

    List slowDownIps = []
    ThesaurusConfigurationEntry slowDownIpsObj = ThesaurusConfigurationEntry.findByKey(REQUEST_LIMIT_IPS)
    if (slowDownIpsObj != null) {
      slowDownIps = slowDownIpsObj.value.split(",")
    }

    ThesaurusConfigurationEntry specialIpConfig = ThesaurusConfigurationEntry.findByKey(REQUEST_LIMIT_SPECIAL_IPS_PREFIX + "-" + ip)
    if (specialIpConfig != null) {
      String[] specialIpConfigValues = specialIpConfig.value.split(";")
      maxAgeSeconds = specialIpConfigValues[0] == "-" ? maxAgeSeconds : Integer.parseInt(specialIpConfigValues[0])
      maxRequests = specialIpConfigValues[1] == "-" ? maxRequests : Integer.parseInt(specialIpConfigValues[1])
      sleepTime = specialIpConfigValues[2] == "-" ? sleepTime : Integer.parseInt(specialIpConfigValues[2])
    }

    String sleepTimeInfo = ""
    if (slowDownIps.contains(ip)) {
      Thread.sleep(sleepTime)
      sleepTimeInfo = "+" + sleepTime + "ms"
    }
    if (ApiRequestEvent.limitReached(ip, apiRequestEvents, maxAgeSeconds, maxRequests)) {
      throw new Exception("Too many requests from your IP address (${IpTools.getRealIpAddress(request)}) - please stop flooding our service. Use http://www.openthesaurus.de/about/download instead.")
    }
    return sleepTimeInfo
  }

}
