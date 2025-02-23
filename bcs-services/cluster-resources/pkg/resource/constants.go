/*
 * Tencent is pleased to support the open source community by making Blueking Container Service available.
 * Copyright (C) 2022 THL A29 Limited, a Tencent company. All rights reserved.
 * Licensed under the MIT License (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * 	http://opensource.org/licenses/MIT
 *
 * Unless required by applicable law or agreed to in writing, software distributed under,
 * the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions and
 * limitations under the License.
 */

package resource

// k8s 资源类型
const (
	// Node ...
	Node = "Node"

	// NS ...
	NS = "Namespace"

	// Deploy ...
	Deploy = "Deployment"
	// RS ...
	RS = "ReplicaSet"
	// DS ...
	DS = "DaemonSet"
	// STS ...
	STS = "StatefulSet"
	// CJ ...
	CJ = "CronJob"
	// Job ...
	Job = "Job"
	// Po ...
	Po = "Pod"

	// Ing ...
	Ing = "Ingress"
	// SVC ...
	SVC = "Service"
	// EP ...
	EP = "Endpoints"

	// CM ...
	CM = "ConfigMap"
	// Secret ...
	Secret = "Secret"

	// PV ...
	PV = "PersistentVolume"
	// PVC ...
	PVC = "PersistentVolumeClaim"
	// SC ...
	SC = "StorageClass"

	// SA ...
	SA = "ServiceAccount"

	// HPA ...
	HPA = "HorizontalPodAutoscaler"

	// CRD ...
	CRD = "CustomResourceDefinition"
	// CObj ...
	CObj = "CustomObject"
)

// BCS 提供自定义类型
const (
	// GDeploy ...
	GDeploy = "GameDeployment"

	// GSTS ...
	GSTS = "GameStatefulSet"

	// HookTmpl ...
	HookTmpl = "HookTemplate"

	// HookRun ...
	HookRun = "HookRun"
)

const (
	// WatchTimeout 执行资源变动 Watch 超时时间 30 分钟
	WatchTimeout = 30 * 60

	// ResCacheTTL 资源信息默认过期时间 14 天
	ResCacheTTL = 14 * 24 * 60 * 60

	// ResCacheKeyPrefix 集群资源信息 Redis 缓存键前缀
	ResCacheKeyPrefix = "osrcp"
)

const (
	// DefaultHPAGroupVersion 特殊指定的 HPA 版本
	DefaultHPAGroupVersion = "autoscaling/v2beta2"
)

// Volume2ResNameKeyMap Pod Volume 字段中，关联的资源类型与 NameKey 映射表
var Volume2ResNameKeyMap = map[string]string{
	PVC:    "claimName",
	Secret: "secretName",
	CM:     "name",
}

const (
	// NamespacedScope 命名空间维度
	NamespacedScope = "Namespaced"

	// ClusterScope 集群维度
	ClusterScope = "Cluster"
)

const (
	// EditModeAnnoKey 资源被编辑的模式，表单为 form，Key 不存在或 Manifest 则为 Yaml 模式
	EditModeAnnoKey = "io.tencent.bcs.editFormat"
	// DeletionProtectLabelKey 删除保护标记使用的 Label 键名
	DeletionProtectLabelKey = "io.tencent.bcs.dev/deletion-allow"
)

const (
	// EditModeForm 资源编辑模式 - 表单
	EditModeForm = "form"
	// EditModeYaml 资源编辑模式 - Yaml
	EditModeYaml = "yaml"
)

const (
	// GDeployDeletionProtectPolicyCascading 实例数量为 0 才可以删除
	GDeployDeletionProtectPolicyCascading = "Cascading"
	// GDeployDeletionProtectPolicyAlways 不限制，任意时候可删除
	GDeployDeletionProtectPolicyAlways = "Always"
	// GDeployDeletionProtectPolicyNotAllow 任意时候都无法删除
	GDeployDeletionProtectPolicyNotAllow = "NotAllow"
)
