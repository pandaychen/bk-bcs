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

package parser

import (
	res "github.com/Tencent/bk-bcs/bcs-services/cluster-resources/pkg/resource"
	"github.com/Tencent/bk-bcs/bcs-services/cluster-resources/pkg/resource/form/parser/custom"
	"github.com/Tencent/bk-bcs/bcs-services/cluster-resources/pkg/resource/form/parser/hpa"
	"github.com/Tencent/bk-bcs/bcs-services/cluster-resources/pkg/resource/form/parser/workload"
)

// Kind2ParseFuncMap 各资源类型对应 ParseFunc
var Kind2ParseFuncMap = map[string]func(manifest map[string]interface{}) map[string]interface{}{
	res.Deploy:   workload.ParseDeploy,
	res.DS:       workload.ParseDS,
	res.STS:      workload.ParseSTS,
	res.CJ:       workload.ParseCJ,
	res.Job:      workload.ParseJob,
	res.Po:       workload.ParsePo,
	res.HPA:      hpa.ParseHPA,
	res.HookTmpl: custom.ParseHookTmpl,
	res.GDeploy:  custom.ParseGDeploy,
}
