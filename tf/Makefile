PLAN_FILE=cf.plan
WORKER_NAME=custom-domain-analytics # TODO: get from tf

HOST:=$(shell hostname)
PREFIX_HOST:=C02ZT5TBMD6P C62W6K1696
HOST_EXIST=$(findstring $(HOST),$(PREFIX_HOST))

ifneq (HOST_EXIST,)
	PREFIX=gk e -p layer0-dev --
else
	PREFIX=
endif
main: plan

plan:
	$(PREFIX) terraform plan -out $(PLAN_FILE)

apply:
	$(PREFIX) terraform apply $(PLAN_FILE)

show:
	terraform show

init:
	terraform init -upgrade

clean:
	rm $(PLAN_FILE)

graph:
	terraform graph | dot -Tsvg > graph.svg

logs: log

log:
	wrangler tail $(WORKER_NAME)


.PHONY: clean plan log logs
