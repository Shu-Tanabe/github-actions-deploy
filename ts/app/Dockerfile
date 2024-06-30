FROM public.ecr.aws/docker/library/node:22.3.0-alpine as deps

WORKDIR /workspace

COPY ./.yarn ./.yarn
COPY ./package.json ./yarn.lock ./.yarnrc.yml ./
COPY ./app/package.json ./app/
RUN yarn install

FROM public.ecr.aws/docker/library/node:22.3.0-alpine as builder

WORKDIR /workspace

COPY --from=deps /workspace/node_modules ./node_modules
COPY . .

RUN yarn workspace app build

FROM public.ecr.aws/docker/library/node:22.3.0-alpine as runner

WORKDIR /app

ENV NODE_ENV production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder --chown=nextjs:nodejs /workspace/app/.next/standalone ./
COPY --from=builder /workspace/app/public ./app/public
COPY --from=builder --chown=nextjs:nodejs /workspace/app/.next/static ./app/.next/static

USER nextjs

EXPOSE 3400

ENV PORT 3400
ENV HOSTNAME "0.0.0.0"

CMD ["node", "app/server.js"]
