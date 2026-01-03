# Introduction

A minimal, hardened Go wrapper for the Trivy rootfs scanner. This tool is designed to generate CycloneDX SBOMs from a root filesystem directory. It is optimized for size and strictly enforces offline, SBOM-only generation without vulnerability scanning or external network requests.

## Design

This wrapper bypasses the standard Trivy CLI entry point to reduce binary size and enforce specific configuration parameters. It imports the pkg/commands/artifact package directly to execute the scanning logic.

### Hardcoded Configuration

The following Trivy options are hardcoded and cannot be overridden by the user:

- Target: Rootfs
- Format: CycloneDX
- Scanners: None (Vulnerability, Secret, and Misconfiguration scanning are disabled)
- Network: Offline mode (no API requests)
- Telemetry: Disabled
- Cache: Memory-only (no disk cache is written)
- Logs: Quiet mode enabled by default

## Prerequisites

Go 1.25 or higher

## Usage

Minimal rootfs scanner for cdxgen

```
trivy-cdxgen [flags] ROOTDIR

Flags:
-h, --help help for trivy-cdxgen
-o, --output string output file name
-v, --version version for trivy-cdxgen
```

## License

Apache-2.0
