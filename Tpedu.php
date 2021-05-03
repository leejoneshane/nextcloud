<?php
/*!
* Hybridauth
* https://hybridauth.github.io | https://github.com/hybridauth/hybridauth
*  (c) 2017 Hybridauth authors | https://hybridauth.github.io/license.html
*/

namespace Hybridauth\Provider;

use Hybridauth\Adapter\OAuth2;
use Hybridauth\Data;
use Hybridauth\Exception\UnexpectedApiResponseException;
use Hybridauth\User;

/**
 * Tpedu OAuth2 provider adapter.
 */
class Tpedu extends OAuth2
{
    /**
     * {@inheritdoc}
     */
    protected $scope = 'profile';

    /**
     * {@inheritdoc}
     */
    protected $apiBaseUrl = 'https://ldap.tp.edu.tw/api/v2/';

    /**
     * {@inheritdoc}
     */
    protected $authorizeUrl = 'https://ldap.tp.edu.tw/oauth/authorize';

    /**
     * {@inheritdoc}
     */
    protected $accessTokenUrl = 'https://ldap.tp.edu.tw/oauth/token';

    /**
     * {@inheritdoc}
     */
    protected $apiDocumentation = 'https://github.com/leejoneshane/tpeduSSO/';

    /**
     * {@inheritdoc}
     */
    public function getUserProfile()
    {
        $response = $this->apiRequest('profile');

        $data = new Data\Collection($response);
        $org = $data->exists('organization') ? $data->get('organization') : false;
        $limit = getenv('ORG', true) ?: 'meps';

        if ($data->exists('error') || !$org) {
            throw new UnexpectedApiResponseException('Provider API returned an unexpected response.');
        } elseif (!property_exists($org, $limit) || $data->get('role') == '家長') {
            throw new UnexpectedApiResponseException('只有'.$limit.'的師生才能登入！');
        }

        $userProfile = new User\Profile();

        if ($data->get('role') == '學生') {
            $userProfile->identifier = $data->get('studentId');
            $userProfile->data['groups'] = ['學生', $data->get('class')];
        } else {
            $userProfile->identifier = $data->get('teacherId');
            if ($data->get('isAdmin') == 'yes') {
                $userProfile->data['groups'][] = 'admin';
            }
            $userProfile->data['groups'][] = '教師';
            $units = $data->get('unit')->$limit;
            foreach ($units as $dept) {
                $userProfile->data['groups'][] = $dept->name;
            }
        }
        $userProfile->displayName = $data->get('name');
        $userProfile->gender = $data->get('gender');
        $userProfile->language = 'zh_TW';
        $userProfile->phone = $data->get('mobile');
        $userProfile->email = $data->get('email');
        $userProfile->emailVerified = ($data->get('email_verified') == 'true') ? $userProfile->email : '';

        return $userProfile;
    }
}
