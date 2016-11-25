GH_PAGES_SOURCES = docs dogs Makefile .nojekyll requirements.txt
PATH = /tmp/django_testing_guide

html:
	cd docs && $(MAKE) html

lint:
	flake8 django_testing_guide --exclude=django_testing_guide/settings.py
	flake8 django_testing_guide/settings.py --ignore=E501
	flake8 dogs
	flake8 docs/conf.py

gh-pages:
	rm -rfv $(PATH)
	git clone git@github.com:massover/django_testing_guide.git /tmp/django_testing_guide
	cd $(PATH); git checkout gh-pages
	cd $(PATH); rm -rf ./*

	cd $(PATH); git checkout master $(GH_PAGES_SOURCES)
	cd $(PATH); git reset HEAD

	cd $(PATH); virtualenv --python=$(which python3) venv
	cd $(PATH); source venv/bin/activate; pip install -r requirements.txt

	cd $(PATH); source venv/bin/activate; make html
	cd $(PATH); mv -fv docs/_build/html/* ./
	cd $(PATH); rm -rf $(GH_PAGES_SOURCES)
	cd $(PATH); git add -A
	cd $(PATH) \
	    && git ci -m "Generated gh-pages for `git log master -1 --pretty=short --abbrev-commit`" \
		&& git push origin gh-pages \
		&& git checkout master