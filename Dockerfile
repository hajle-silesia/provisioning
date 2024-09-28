# Docker image customizing
# Source: https://github.com/cloudposse/geodesic#customizing-your-docker-image
ARG GEODESIC_REPOSITORY=cloudposse/geodesic
ARG GEODESIC_TAG=3.3.0-debian

# renovate: datasource=github-releases depName=jdx/mise
ARG MISE_VERSION=v2024.9.11

FROM ${GEODESIC_REPOSITORY}:${GEODESIC_TAG}

ENV BANNER="toolbox"

ENV DOCKER_IMAGE="mtweeman/hajle-silesia_provisioning-toolbox"
ENV DOCKER_TAG="latest"

# Add system-wide git safe directory to avoid ownership issues in the filesystem.
# Reasoning: in the remote (CI/CD workflows) or local usage of this image, the user cloning the repository will be different than the one operating on it.
COPY .gitconfig /etc/gitconfig

# Mise installation
# Source: https://mise.jdx.dev/getting-started.html
ARG MISE_VERSION
ARG MISE_INSTALL_PATH="/usr/local/bin/mise"
ARG MISE_DATA_DIR="/usr/share/xdg_data_home/mise"
RUN curl https://mise.run | \
    MISE_VERSION="${MISE_VERSION}" \
    MISE_INSTALL_PATH="${MISE_INSTALL_PATH}" \
    MISE_DATA_DIR="${MISE_DATA_DIR}" \
    sh
ENV PATH="${MISE_DATA_DIR}/shims:$PATH"
# Defaults for all users
# Source: https://mise.jdx.dev/configuration.html#system-config-etc-mise-config-toml
COPY .mise.toml /etc/mise/config.toml
# Install tools
# Source: https://mise.jdx.dev/cli/install.html
RUN mise install --yes

# Add system-wide git safe directory to avoid ownership issues in the filesystem.
# Reasoning: in the remote (CI/CD workflows) or local usage of this image, the user cloning the repository will be different than the one operating on it.
COPY .gitconfig /etc/gitconfig

# Atmos configuration
# Source: https://atmos.tools/core-concepts/components/terraform/remote-state/#recommended-options
COPY rootfs/ /
