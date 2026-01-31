FROM rocker/shiny-verse:4.4.0

# Install system dependencies for Chrome and chrome-headless-shell
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    gnupg \
    ca-certificates \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libdrm2 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libxss1 \
    lsb-release \
    xdg-utils \
    libgbm1 \
    libxrandr2 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3

# Download and install chrome-headless-shell (fixes Chrome 134+ issues)
RUN wget -q https://storage.googleapis.com/chrome-for-testing-public/131.0.6778.85/linux64/chrome-headless-shell-linux64.zip \
    && unzip chrome-headless-shell-linux64.zip \
    && cp -r chrome-headless-shell-linux64/* /usr/local/bin/ \
    && chmod +x /usr/local/bin/chrome-headless-shell \
    && rm -rf chrome-headless-shell-linux64*

# Clean up
RUN rm -rf /var/lib/apt/lists/*

# Set environment variable for chromote to use headless shell
ENV CHROMOTE_CHROME="/usr/local/bin/chrome-headless-shell"

# Configure Chrome arguments for Docker environment (fixes window.shinytest2.ready timeout)
ENV CHROMOTE_CHROME_ARGS="--no-sandbox --no-proxy-server --disable-dev-shm-usage --disable-gpu --remote-debugging-port=9222"

# Install R package dependencies
RUN R -e "install.packages('devtools')"

# Allow non-root users to install R packages (for --user docker runs)
RUN chmod -R a+w /usr/local/lib/R/site-library

# Set working directory
WORKDIR /pkg

# Pre-install package deps (layer cached until DESCRIPTION changes)
COPY DESCRIPTION .
RUN R -e "devtools::install_deps(dependencies = TRUE)"

# Default command
CMD ["R"]
