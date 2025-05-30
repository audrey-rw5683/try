# syntax=docker/dockerfile:1
ARG NODE_VERSION=24-alpine
FROM node:${NODE_VERSION}

# 1. 指定工作目录
WORKDIR /usr/src/app

# 2. 先复制 package.json & package-lock.json，用于利用缓存
COPY aaa/package.json       package.json
COPY aaa/package-lock.json  package-lock.json

# 3. 安装生产依赖；此时仍以 root 身份执行
RUN npm ci --omit=dev

# 4. 把项目目录下所有源代码都复制进来（包括 public/、src/），并让 node 用户拥有它们
COPY --chown=node:node aaa/ ./

# 5. 因为上一步拷贝的只是源码，node_modules 均是 root:root 拥有，
#    所以这里把 /usr/src/app 下所有东西一并改成 node:node，保证后续运行时没有权限问题
RUN chown -R node:node /usr/src/app

# 6. 切换到非 root 用户 node
USER node

# 7. 暴露容器端口（根据你的应用实际监听端口填写，这里假设是 3008）
EXPOSE 3008

# 8. 启动命令
CMD ["npm", "start"]

