# Changelog

## [2.11.0](https://github.com/gersonrs/modern-gitops-stack-module-minio/compare/v2.10.0...v2.11.0) (2026-07-08)


### 🚀 New Features

* adjust somethings ([d7990e8](https://github.com/gersonrs/modern-gitops-stack-module-minio/commit/d7990e85847ef0d57e98881e22801161fe3a3906))
* adjust somethings ([d7f2766](https://github.com/gersonrs/modern-gitops-stack-module-minio/commit/d7f2766a0f699400fef230877ff85680162a3f25))

## [2.10.0](https://github.com/gersonrs/modern-gitops-stack-module-minio/compare/v2.9.0...v2.10.0) (2026-07-08)


### 🚀 New Features

* remove redundant certificate ([37615ac](https://github.com/gersonrs/modern-gitops-stack-module-minio/commit/37615accc65416c08a7f1396c6cc1d5bb4c149c7))
* remove redundant certificate ([19f38f2](https://github.com/gersonrs/modern-gitops-stack-module-minio/commit/19f38f28b8ea807b8cca943ab8bdcaafebbd0005))


### 🔥 Bug Fixes

* restore minio oidc trust with internal ca secret ([9e4c2a7](https://github.com/gersonrs/modern-gitops-stack-module-minio/commit/9e4c2a75427e0dd1020483a8ecd1abb9575cadfd))
* restore minio OIDC trust with internal CA secret ([e2cc447](https://github.com/gersonrs/modern-gitops-stack-module-minio/commit/e2cc4474f873d58adcf05933b4e083197ccb94b1))


### 📚 Documentation

* **terraform-docs:** gerar docs e escrever no README.adoc ([0b86817](https://github.com/gersonrs/modern-gitops-stack-module-minio/commit/0b86817e4f8dcb04a13f548a5def3b79bfd66f0c))


### ⚙️ Chores

* release 2.10.0 ([9bb3d22](https://github.com/gersonrs/modern-gitops-stack-module-minio/commit/9bb3d22e88b578b9e6502156bf8837d261ee38ce))
* release 2.10.0 ([d30e227](https://github.com/gersonrs/modern-gitops-stack-module-minio/commit/d30e227164f4fae92b3a3febce482f4b6c2cb4d5))
* rollback main to v2.9.0 ([6f72c90](https://github.com/gersonrs/modern-gitops-stack-module-minio/commit/6f72c905513a869f7a941584d3cf139e4e73dbdf))

## [2.9.0](https://github.com/gersonrs/modern-gitops-stack-module-minio/compare/v2.8.0...v2.9.0) (2026-05-19)


### 🚀 New Features

* add cert-manager Certificate template and pass cluster_issuer to chart values ([d053015](https://github.com/gersonrs/modern-gitops-stack-module-minio/commit/d0530152da7ff1b129486838441f1a860bdd59e1))
* add gateway_name and gateway_namespace variables ([0f09e86](https://github.com/gersonrs/modern-gitops-stack-module-minio/commit/0f09e866987988315fd0988b1f5c9ca5c17248f8))
* migrate from Traefik Ingress to Istio HTTPRoute (Gateway API) ([119fcbd](https://github.com/gersonrs/modern-gitops-stack-module-minio/commit/119fcbd9637f08436b85531b1ea75979983f3acc))
* migrate to Istio HTTPRoute and add cert-manager Certificate ([dc11d8f](https://github.com/gersonrs/modern-gitops-stack-module-minio/commit/dc11d8f776f3f610ba87a7e8a39a85e579fef8de))
* redirect HTTP to HTTPS via separate HTTPRoutes with sectionName ([6134422](https://github.com/gersonrs/modern-gitops-stack-module-minio/commit/6134422fc7f7605b03f8c9d51b5ac500e9f254c2))


### 🔥 Bug Fixes

* derive redirectUri scheme from oidc.issuer_url to support http for non-prod ([4a048b3](https://github.com/gersonrs/modern-gitops-stack-module-minio/commit/4a048b3fb063196e179e1735bf5a5467e3383355))
* use .Values.minio.cluster_issuer in Certificate template condition ([57e9a0d](https://github.com/gersonrs/modern-gitops-stack-module-minio/commit/57e9a0df90b831afeb65bcccb8ab464519c19bd4))


### ⌨️ Code Refactoring

* simplify HTTPRoute to use sectionName https only ([58fc828](https://github.com/gersonrs/modern-gitops-stack-module-minio/commit/58fc8280656dfcba19e87e0dab4952f90467336c))

## [2.8.0](https://github.com/GersonRS/modern-gitops-stack-module-minio/compare/v2.7.0...v2.8.0) (2026-01-26)


### 🚀 New Features

* adjust workflow ([95179e8](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/95179e84f29cdc98c8487237ae0eb430fe9afa09))
* update chart ([6c2bf43](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/6c2bf4351a2216d53499713d9f4224d34daba345))
* update the things ([6a184cd](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/6a184cd71759b42dab89aaf573a12822d4ba00e9))

## [2.7.0](https://github.com/GersonRS/modern-gitops-stack-module-minio/compare/v2.6.2...v2.7.0) (2025-10-20)


### 🚀 New Features

* add validation ([e43632d](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/e43632dc2326237de7d7f20af56390246f56eec8))
* adiciona configurações detalhadas do ServiceMonitor para métricas do Prometheus ([f95e3ee](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/f95e3ee05bd5e2da495e416e3426087fa9f498a8))
* adjust code ([d13b59c](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/d13b59cd24ff40a53097f66d5e6863a4ed515694))
* **chart:** minor update of dependencies on minio chart ([dc81100](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/dc811008c01e4578302ce336bc47ffa6bb895854))
* **chart:** minor update of dependencies on minio chart ([ad05b3c](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/ad05b3c6fbfb19ce1b2a1114d83d939ebc88c93a))
* melhorias na configuração do MinIO e validação de persistência ([4e57cab](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/4e57cabfa6182b3295b71d5838436586d40ebb2e))


### 🔥 Bug Fixes

* adiciona validação para tamanho mínimo de persistência de 10GB ([4fd95a7](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/4fd95a7bc0b6cc01bbe817e3727f691ab7585966))

## [2.6.2](https://github.com/GersonRS/modern-gitops-stack-module-minio/compare/v2.6.1...v2.6.2) (2025-02-08)


### ⌨️ Code Refactoring

* adjust workflows ([b9fdfed](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/b9fdfed19a692ea34d58dbe37134bd42359578eb))
* try adjust code 5 ([547d7fc](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/547d7fc1f6f26807669beaefc2b1c92fa00ca958))

## [2.6.1](https://github.com/GersonRS/modern-gitops-stack-module-minio/compare/v2.6.0...v2.6.1) (2025-01-18)


### 📚 Documentation

* **terraform-docs:** generate docs and write to README.adoc ([a1a8778](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/a1a8778e5a86e2f7066fada8c0f4c1ca80517b40))

## [2.6.0](https://github.com/GersonRS/modern-gitops-stack-module-minio/compare/v2.5.0...v2.6.0) (2025-01-18)


### 🚀 New Features

* update project ([e3fe7a9](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/e3fe7a9c21543295026f4e7543fd4dee26252107))

## [2.5.0](https://github.com/GersonRS/modern-gitops-stack-module-minio/compare/v2.4.0...v2.5.0) (2024-05-01)


### 🚀 New Features

* change chart update to include secrets ([5953029](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/59530294ae4377b6ec163d44f42fe7e79ef4bd13))


### 📚 Documentation

* **terraform-docs:** generate docs and write to README.adoc ([e009d6b](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/e009d6bac4e14fa2edc024d1a55d7e65c383cabb))

## [2.4.0](https://github.com/GersonRS/modern-gitops-stack-module-minio/compare/v2.3.0...v2.4.0) (2024-05-01)


### 🚀 New Features

* add pre-commit, config release-please workflow and adjust add-to-project workflow ([1297a4d](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/1297a4d3c500c07a0975f4f9b31b2ee5846ce1d1))
* finish configuration ([42d3c3b](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/42d3c3bb399e003ce95513457b9ceae1be269719))
* include page in documentation ([d6d495d](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/d6d495d8d0ca4fbd587aa0acd2fe8955850a0d94))
* module modularization ([f0f6f48](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/f0f6f48b11ab448280f1c809e4ddfbb781a4a495))
* module modularization ([93ddc18](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/93ddc1805cc5cb6eabf8e18c6602d3e73a5543ee))
* Update minio config and change mode to distributed mode ([cca6ff1](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/cca6ff1eed86264a89d44fd8fa314af6d8e6a87e))


### 🔥 Bug Fixes

* adjust module target revision ([2479aea](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/2479aea5459a3a09002061efb8c37b4084c5dc14))


### 📚 Documentation

* **pull_request:** update pull request template ([72f8b15](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/72f8b1535bf1c7e2f3f081debf90cea34b3fc5ef))
* **terraform-docs:** generate docs and write to README.adoc ([9477c8e](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/9477c8ea11903f69fda72ec51b3cc13db703b93d))
* **terraform-docs:** generate docs and write to README.adoc ([d7e9806](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/d7e9806c63124b66dd3d25fa5259a997cc280860))


### ⚙️ Chores

* release 1.0.0 ([1aa4277](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/1aa4277287af68ac86105686a6bb12ce1feaad2e))
* release 1.1.0 ([bba3ae9](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/bba3ae9232b9f0c5e5dc818b12333b5e0b1f094d))
* release 1.2.0 ([4e2f211](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/4e2f2114331fd6b1aceecc449092a65bb91b7f44))

## [1.2.0](https://github.com/GersonRS/modern-gitops-stack-module-minio/compare/v1.1.0...v1.2.0) (2024-04-28)


### Features

* Update minio config and change mode to distributed mode ([cca6ff1](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/cca6ff1eed86264a89d44fd8fa314af6d8e6a87e))

## [1.1.0](https://github.com/GersonRS/modern-gitops-stack-module-minio/compare/v1.0.0...v1.1.0) (2024-04-26)


### Features

* include page in documentation ([d6d495d](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/d6d495d8d0ca4fbd587aa0acd2fe8955850a0d94))


### Bug Fixes

* adjust module target revision ([2479aea](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/2479aea5459a3a09002061efb8c37b4084c5dc14))

## 1.0.0 (2024-04-24)


### Features

* finish configuration ([42d3c3b](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/42d3c3bb399e003ce95513457b9ceae1be269719))
* module modularization ([f0f6f48](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/f0f6f48b11ab448280f1c809e4ddfbb781a4a495))
* module modularization ([93ddc18](https://github.com/GersonRS/modern-gitops-stack-module-minio/commit/93ddc1805cc5cb6eabf8e18c6602d3e73a5543ee))
