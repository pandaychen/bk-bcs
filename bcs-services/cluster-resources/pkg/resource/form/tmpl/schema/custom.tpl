{{- define "custom.hookTmplSpec" }}
spec:
  title: {{ i18n "配置信息" .lang }}
  type: object
  properties:
    args:
      title: {{ i18n "参数定义" .lang }}
      type: array
      description: {{ i18n "metrics 中引用自定义参数的方式为 {{ args.自定参数键 }}<br>除了支持引用自定义参数，还支持引用内置参数，具体内置参数如下：<br>当前 Pod IP：{{ args.PodIP }}<br>当前 Pod 名称：{{ args.PodName }}<br>Pod 所在命名空间：{{ args.PodNamespace }}<br>第 idx 个容器名称：{{ args.PodContainer[idx] }}（首个容器 idx 值为 0）<br>第 idx 个修改容器名称：{{ args.ModifiedContainer[idx] }}（原地更新模式）<br>Pod HostIP：{{ args.HostIP }}" .lang }}
      items:
        type: object
        properties:
          key:
            title: {{ i18n "键" .lang }}
            type: string
            ui:rules:
              - required
              - maxLength128
          value:
            title: {{ i18n "值" .lang }}
            type: string
            ui:rules:
              - maxLength128
            ui:component:
              props:
                placeholder: {{ i18n "值，可为空（由创建 HookRun 时传入）" .lang }}
      ui:component:
        name: noTitleArray
      ui:props:
        showTitle: true
    policy:
      title: {{ i18n "Metric 执行策略" .lang }}
      type: string
      default: Parallel
      description: {{ i18n "并行执行：在执行时会并行执行所有 metrics；顺序执行（BcsHook-Operator 1.27.0+ 支持）：执行时顺序执行所有metrics，只有上个 metric 执行结束后才会继续执行下个 metric" .lang }}
      ui:component:
        name: radio
        props:
          datasource:
            - label: {{ i18n "并行执行" .lang }}
              value: Parallel
            - label: {{ i18n "顺序执行" .lang }}
              value: Ordered
    metrics:
      title: {{ i18n "Metric 定义" .lang }}
      type: array
      items:
        type: object
        required:
          - name
          - hookType
          - url
          - jsonPath
          - timeoutSecs
          - address
          - query
          - function
          - fields
          - count
          - interval
          - successConditionExp
          - successPolicy
          - successCnt
        properties:
          name:
            title: {{ i18n "名称" .lang }}
            type: string
            ui:rules:
              - required
              - maxLength128
              - nameRegex
          hookType:
            title: {{ i18n "Hook 类型" .lang }}
            type: string
            default: web
            ui:component:
              name: select
              props:
                clearable: false
                datasource:
                  - label: WebHook
                    value: web
                  - label: Prometheus
                    value: prometheus
                  - label: Kubernetes
                    value: kubernetes
            ui:reactions:
              - target: "{{`{{`}} $widgetNode?.getSibling('url')?.id {{`}}`}}"
                if: "{{`{{`}} $self.value === 'web' {{`}}`}}"
                then:
                  state:
                    visible: true
                else:
                  state:
                    visible: false
              - target: "{{`{{`}} $widgetNode?.getSibling('jsonPath')?.id {{`}}`}}"
                if: "{{`{{`}} $self.value === 'web' {{`}}`}}"
                then:
                  state:
                    visible: true
                else:
                  state:
                    visible: false
              - target: "{{`{{`}} $widgetNode?.getSibling('timeoutSecs')?.id {{`}}`}}"
                if: "{{`{{`}} $self.value === 'web' {{`}}`}}"
                then:
                  state:
                    visible: true
                else:
                  state:
                    visible: false
              - target: "{{`{{`}} $widgetNode?.getSibling('address')?.id {{`}}`}}"
                if: "{{`{{`}} $self.value === 'prometheus' {{`}}`}}"
                then:
                  state:
                    visible: true
                else:
                  state:
                    visible: false
              - target: "{{`{{`}} $widgetNode?.getSibling('query')?.id {{`}}`}}"
                if: "{{`{{`}} $self.value === 'prometheus' {{`}}`}}"
                then:
                  state:
                    visible: true
                else:
                  state:
                    visible: false
              - target: "{{`{{`}} $widgetNode?.getSibling('function')?.id {{`}}`}}"
                if: "{{`{{`}} $self.value === 'kubernetes' {{`}}`}}"
                then:
                  state:
                    visible: true
                else:
                  state:
                    visible: false
              - target: "{{`{{`}} $widgetNode?.getSibling('fields')?.id {{`}}`}}"
                if: "{{`{{`}} $self.value === 'kubernetes' {{`}}`}}"
                then:
                  state:
                    visible: true
                else:
                  state:
                    visible: false
          url:
            type: string
            description: {{ i18n "webhook 调用的地址，目前只支持 get 请求，返回值必须是 json 格式" .lang }}
            ui:rules:
              - maxLength250
              - validator: "{{`{{`}} $widgetNode?.getSibling('hookType')?.instance?.value !== 'web' || $self.value !== '' {{`}}`}}"
                message: {{ i18n "值不能为空" .lang }}
            ui:component:
              props:
                placeholder: "http://1.1.1.1:8080/thenextweb/test/?podname={{`{{`}} args.PodName {{`}}`}}"
          timeoutSecs:
            title: {{ i18n "请求超时时间" .lang }}
            type: integer
            default: 10
            ui:component:
              name: unitInput
              props:
                max: 86400
                unit: s
          jsonPath:
            type: string
            description: {{ i18n "提取返回 json 中的某个字段" .lang }}
            ui:rules:
              - maxLength128
              - validator: "{{`{{`}} $widgetNode?.getSibling('hookType')?.instance?.value !== 'web' || $self.value !== '' {{`}}`}}"
                message: {{ i18n "值不能为空" .lang }}
            ui:component:
              props:
                placeholder: "{{`{`}}$.result{{`}`}}"
          address:
            type: string
            ui:rules:
              - maxLength250
              - validator: "{{`{{`}} $widgetNode?.getSibling('hookType')?.instance?.value !== 'prometheus' || $self.value !== '' {{`}}`}}"
                message: {{ i18n "值不能为空" .lang }}
            ui:component:
              props:
                placeholder: "http://po-prometheus-operator-prometheus.thanos.svc.cluster.local:9090"
          query:
            type: string
            ui:rules:
              - maxLength250
              - validator: "{{`{{`}} $widgetNode?.getSibling('hookType')?.instance?.value !== 'prometheus' || $self.value !== '' {{`}}`}}"
                message: {{ i18n "值不能为空" .lang }}
            ui:component:
              props:
                placeholder: 'prometheus_operator_watch_operations_failed_total{controller="alertmanager"}'
          function:
            type: string
            default: get
            ui:component:
              name: select
              props:
                clearable: false
                datasource:
                  - label: Get
                    value: get
                  - label: Patch
                    value: patch
          fields:
            type: array
            items:
              type: object
              properties:
                key:
                  title: {{ i18n "键" .lang }}
                  type: string
                  ui:rules:
                    - required
                    - maxLength128
                value:
                  title: {{ i18n "值" .lang }}
                  type: string
                  ui:rules:
                    - maxLength64
              ui:rules:
                - validator: "{{`{{`}} $widgetNode?.getSibling('hookType')?.instance?.value !== 'kubernetes' || $self.value.length > 0 {{`}}`}}"
                  message: {{ i18n "至少包含一对 fields" .lang }}
            ui:component:
              name: noTitleArray
            ui:props:
              showTitle: true
          count:
            type: integer
            default: 0
            description: {{ i18n "count 表示该 metric 需要完成 hook 调用的次数，若 count 为 0，将会无限制地一直进行 hook 调用，直到满足统计策略后才会返回 OK；若 count 不为 0，则无视成功条件与统计策略，即运行达到 count 次数后直接返回 OK" .lang }}
            ui:component:
              props:
                max: 4096
          interval:
            type: integer
            default: 1
            description: {{ i18n "interval 表示两次 hook 调用的时间间隔，取值范围为 1-86400 秒。" .lang }}
            ui:component:
              props:
                min: 1
                max: 86400
          successConditionExp:
            title: {{ i18n "成功条件表达式" .lang }}
            type: string
            ui:component:
              props:
                placeholder: "asInt(result) == 1"
            ui:rules:
              - required
              - maxLength128
          successPolicy:
            title: {{ i18n "统计策略" .lang }}
            type: string
            default: successfulLimit
            ui:component:
              name: radio
              props:
                datasource:
                  - label: {{ i18n "累计成功次数" .lang }}
                    value: successfulLimit
                  - label: {{ i18n "连续成功次数" .lang }}
                    value: consecutiveSuccessfulLimit
          successCnt:
            title: {{ i18n "次数" .lang }}
            type: integer
            default: 1
            ui:component:
              props:
                min: 1
                max: 7200
        ui:group:
          props:
            showTitle: false
            type: normal
          style:
            background: '#F5F7FA'
  ui:group:
    props:
      border: true
      showTitle: true
      type: card
{{- end }}

{{- define "custom.gdeployReplicas" }}
replicas:
  title: {{ i18n "副本管理" .lang }}
  type: object
  properties:
    cnt:
      title: {{ i18n "副本数量" .lang }}
      type: integer
      default: 1
      ui:component:
        props:
          max: 4096
    updateStrategy:
      title: {{ i18n "升级策略" .lang }}
      type: string
      default: RollingUpdate
      description: {{ i18n "原地升级策略只支持以原地重启容器的方式更新 image 字段，或以不重启不重建的方式更新 labels/annotations 字段；若更改除此之外的其它字段，则此次原地更新会卡住！" .lang }}
      ui:component:
        name: radio
        props:
          datasource:
            - label: {{ i18n "滚动升级" .lang }}
              value: RollingUpdate
            - label: {{ i18n "原地升级" .lang }}
              value: InplaceUpdate
      ui:reactions:
        - target: "{{`{{`}} $widgetNode?.getSibling('gracePeriodSecs')?.id {{`}}`}}"
          if: "{{`{{`}} $self.value === 'InplaceUpdate' {{`}}`}}"
          then:
            state:
              visible: true
          else:
            state:
              visible: false
    maxSurge:
      title: {{ i18n "最大调度 Pod 数量" .lang }}
      type: integer
      default: 0
      ui:component:
        props:
          max: 4096
      ui:rules:
        - validator: "{{`{{`}} $self.getValue('spec.replicas.maxUnavailable') !== 0 || $self.value !== 0 {{`}}`}}"
          message: {{ i18n "最大调度 Pod 数量 与最大不可用数量不可均为 0" .lang }}
    msUnit:
      title: {{ i18n "单位" .lang }}
      type: string
      default: cnt
      ui:component:
        name: select
        props:
          clearable: false
          datasource:
            - label: '%'
              value: percent
            - label: {{ i18n "个" .lang }}
              value: cnt
    maxUnavailable:
      title: {{ i18n "最大不可用数量" .lang }}
      type: integer
      default: 20
      ui:component:
        props:
          max: 4096
      ui:rules:
        - validator: "{{`{{`}} $self.getValue('spec.replicas.maxSurge') !== 0 || $self.value !== 0 {{`}}`}}"
          message: {{ i18n "最大调度 Pod 数量 与最大不可用数量不可均为 0" .lang }}
    muaUnit:
      title: {{ i18n "单位" .lang }}
      type: string
      default: percent
      ui:component:
        name: select
        props:
          clearable: false
          datasource:
            - label: '%'
              value: percent
            - label: {{ i18n "个" .lang }}
              value: cnt
    minReadySecs:
      title: {{ i18n "最小就绪时间" .lang }}
      type: integer
      default: 0
      ui:component:
        name: unitInput
        props:
          max: 2147483647
          unit: s
    partition:
      title: {{ i18n "保留旧版本实例数量" .lang }}
      type: integer
      default: 0
      ui:component:
         name: unitInput
         props:
           max: 4096
           unit: {{ i18n "个" .lang }}
    gracePeriodSecs:
      title: {{ i18n "优雅更新时间" .lang }}
      type: integer
      default: 30
      ui:component:
        name: unitInput
        props:
          max: 86400
          unit: s
{{- end }}

{{- define "custom.gdeployGracefulManage" }}
gracefulManage:
  title: {{ i18n "优雅删除/更新" .lang }}
  type: object
  properties:
    preDeleteHook:
      title: PreDeleteUpdateStrategy
      type: object
      {{- include "custom.gdeployUpdateHook" . | indent 6 }}
    preInplaceHook:
      title: PreInplaceUpdateStrategy
      type: object
      {{- include "custom.gdeployUpdateHook" . | indent 6 }}
    postInplaceHook:
      title: PostInplaceUpdateStrategy
      type: object
      {{- include "custom.gdeployUpdateHook" . | indent 6 }}
  ui:group:
    name: collapse
  ui:order:
    - preDeleteHook
    - preInplaceHook
    - postInplaceHook
{{- end }}

{{- define "custom.gdeployUpdateHook" }}
required:
  - tmplName
properties:
  enabled:
    title: {{ i18n "启用" .lang }}
    type: boolean
    default: false
    ui:reactions:
      - target: "{{`{{`}} $widgetNode?.getSibling('tmplName')?.id {{`}}`}}"
        if: "{{`{{`}} $self.value {{`}}`}}"
        then:
          state:
            visible: true
        else:
          state:
            visible: false
      - target: "{{`{{`}} $widgetNode?.getSibling('args')?.id {{`}}`}}"
        if: "{{`{{`}} $self.value {{`}}`}}"
        then:
          state:
            visible: true
        else:
          state:
            visible: false
  tmplName:
    title: Hook Template
    type: string
    ui:component:
      name: select
      props:
        clearable: false
        searchable: true
        remoteConfig:
          # TODO 需要确认 params 能否支持动态获取 namespace，目前是直接渲染到 url 中
          url: "{{`{{`}} `${$context.baseUrl}/projects/${$context.projectID}/clusters/${$context.clusterID}/crds/hooktemplates.tkex.tencent.com/custom_objects?namespace=${$self.getValue('metadata.namespace')}&format=selectItems` {{`}}`}}"
    ui:reactions:
      - lifetime: init
        then:
          actions:
            - "{{`{{`}} $loadDataSource {{`}}`}}"
      - source: "metadata.namespace"
        then:
          actions:
            - "{{`{{`}} $loadDataSource {{`}}`}}"
    ui:rules:
      - validator: "{{`{{`}} !$widgetNode?.getSibling('enabled')?.instance?.value || $self.value !== '' {{`}}`}}"
        message: {{ i18n "值不能为空" .lang }}
  args:
    title: {{ i18n "Hook 传入参数" .lang }}
    type: array
    items:
      type: object
      properties:
        key:
          title: {{ i18n "键" .lang }}
          type: string
          ui:rules:
            - required
            - maxLength128
        value:
          title: {{ i18n "值" .lang }}
          type: string
          ui:rules:
            - maxLength64
    ui:component:
      name: noTitleArray
    ui:props:
      showTitle: true
{{- end }}

{{- define "custom.gdeploydeletionProtect" }}
deletionProtect:
  title: {{ i18n "删除保护" .lang }}
  type: object
  properties:
    policy:
      title: {{ i18n "策略" .lang }}
      type: string
      default: Always
      ui:component:
        name: select
        props:
          clearable: false
          datasource:
            - label: {{ i18n "实例数为 0 时可删除" .lang }}
              value: Cascading
            - label: {{ i18n "总是允许删除" .lang }}
              value: Always
            - label: {{ i18n "不允许删除" .lang }}
              value: NotAllow
{{- end }}
