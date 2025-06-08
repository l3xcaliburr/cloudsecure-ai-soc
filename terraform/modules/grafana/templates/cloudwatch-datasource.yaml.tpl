apiVersion: 1

datasources:
  - name: CloudWatch
    type: cloudwatch
    access: proxy
    uid: cloudwatch_uid
    editable: true
    isDefault: true
    jsonData:
      authType: default
      defaultRegion: ${aws_region}
      customMetricsNamespaces: 'CWAgent,AWS/Lambda,AWS/ApplicationELB,AWS/WAF'
      assumeRoleArn: ''
    secureJsonData: {}
    version: 1

  - name: CloudWatch Logs
    type: cloudwatch
    access: proxy
    uid: cloudwatch_logs_uid
    editable: true
    jsonData:
      authType: default
      defaultRegion: ${aws_region}
      logGroups: []
    secureJsonData: {}
    version: 1