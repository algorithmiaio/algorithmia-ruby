module Algorithmia
  class Client
    attr_reader :api_key
    attr_reader :api_address

    def initialize(api_key, api_address=nil)
      @api_key = api_key
      @api_address = api_address || ENV['ALGORITHMIA_API'] || "https://api.algorithmia.com"
    end

    def algo(endpoint, path = '/v1/algo/')
      Algorithmia::Algorithm.new(self, endpoint.prepend(path))
    end

    def get_algo(user_name, algo_name)
      algo(user_name.concat('/').concat(algo_name), '/v1/algorithms/').get_algo
    end

    def get_algo_versions(user_name, algo_name, callable, limit, published, marker)
      algo(user_name.concat('/').concat(algo_name).concat('/versions'), '/v1/algorithms/')
          .algo_versions(callable, limit, published, marker)
    end

    def get_algo_builds(user_name, algo_name, limit, marker)
      algo(user_name.concat('/').concat(algo_name).concat('/builds'), '/v1/algorithms/')
          .algo_builds(limit, marker)
    end

    def list_scms()
      algo('', '/v1/scms').list_scms
    end

    def get_scm(scm_id)
      algo('/'.concat(scm_id), '/v1/scms').get_scm
    end

    def get_scm_status(user_name, algo_name)
      algo(user_name.concat('/').concat(algo_name).concat('/scm/status'), '/v1/algorithms/').get_scm_status
    end

    def get_algo_build_logs(user_name, algo_name, build_id)
      algo(user_name.concat('/').concat(algo_name)
               .concat('/builds/').concat(build_id)
               .concat('/logs'), '/v1/algorithms/')
          .algo_build_logs
    end

    def revoke_scm_status(scm_id)
      algo(scm_id.concat('/oauth/revoke'), '/v1/scms/').revoke_scm_status
    end

    def delete_algo(user_name, algo_name)
      algo(user_name.concat('/').concat(algo_name), '/v1/algorithms/').delete_algo
    end

    def create_organization(organization)
      algo('/organizations', '/v1').create_organization(organization)
    end

    def update_organization(org_name, organization)
      algo("/organizations/#{org_name}", '/v1').update_organization(organization)
    end

    def get_organization(org_name)
      algo("/organizations/#{org_name}", '/v1').get_organization
    end

    def delete_organization(org_name)
      algo("/organizations/#{org_name}", '/v1').delete_organization
    end

    def file(endpoint)
      Algorithmia::DataFile.new(self, endpoint)
    end

    def dir(endpoint)
      Algorithmia::DataDirectory.new(self, endpoint)
    end
  end
end
